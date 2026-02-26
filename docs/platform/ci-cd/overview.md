# Pipeline Overview

The CI/CD pipeline is a **four-stage automated release workflow** that transforms commits into versioned artifacts and deployed documentation.

## Pipeline Stages

### Stage 1: Trigger and prepare release PR

**Workflows:** [`Bump API`](bump-api.md) and [`Bump Web`](bump-web.md)

When code is committed to `services/api/**` or `services/web/**`, the corresponding bump workflow automatically:

- **Bump API** (Python service):
    - Bumps the version in `services/api/pyproject.toml` (patch/minor/major)
    - Generates a changelog using `git-cliff` from commits matching `api-v*` tag pattern
    - Creates a release PR with the changelog as the PR body, labeled `release`

- **Bump Web** (Node.js service):
    - Bumps the version in `services/web/package.json` (patch/minor/major)
    - Generates a changelog using `git-cliff` from commits matching `web-v*` tag pattern
    - Creates a release PR with the changelog as the PR body, labeled `release`

Both workflows can be manually triggered via `workflow_dispatch` with a version bump input.

**Guard:** Both workflows skip if the commit is a release PR merge (detected by `release/api-v` or `release/web-v` in commit message), preventing automatic re-triggering.

### Stage 2: Merge and create Git tag

**Workflow:** [`Create Release Tag`](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/create-tag.yml)

When a PR with the `release` label and a branch matching `release/*` is merged to `main`:

- Parses the tag name from the branch (for example, `release/api-v1.2.3` becomes `api-v1.2.3`)
- Configures git user as `github-actions[bot]`
- Creates and pushes the tag to origin

This tag serves as the version marker and triggers downstream workflows.

### Stage 3: Tag and build artifacts

**Workflow:** [`Publish Artifacts`](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/docker-publish.yml)

Triggered by the same conditions as Stage 2 (merged release PR):

- Extracts service name and version from the branch name
- Validates the service directory exists (e.g., `services/api`)
- Logs into GitHub Container Registry (GHCR)
- Builds and pushes Docker image with version tag and `latest` tag
- Creates a GitHub Release with the service changelog

**Output:** Published Docker image at `ghcr.io/<owner>/<service>:v<version>` and GitHub Release.

### Stage 4: Push docs and deploy

**Workflow:** [`Documentation`](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/docs.yml)

Triggered on push to `main` when `docs/**` or `zensical.toml` changes:

- Checks out Python 3.14 runtime
- Installs `zensical` (custom doc builder)
- Builds the site with `--clean` flag
- Uploads artifact and deploys to GitHub Pages

Also supports manual trigger via `workflow_dispatch`.

## Workflow Dependencies

### Service Releases

**API**

1. Commit in `services/api/**` triggers Bump API to create a release PR.
2. Merge the release PR with the `release` label triggers Create Release Tag and Publish Artifacts.
3. Create Release Tag pushes the tag; Publish Artifacts builds and publishes the image and release.

**Web**

1. Commit in `services/web/**` triggers Bump Web to create a release PR.
2. Merge the release PR with the `release` label triggers Create Release Tag and Publish Artifacts.
3. Create Release Tag pushes the tag; Publish Artifacts builds and publishes the image and release.

### Documentation Deployment

1. Commit in `docs/**` or a change to `zensical.toml` triggers the Documentation workflow to build and deploy the site.

## Permissions Model

Each workflow requests minimal permissions required:

| Workflow | Permissions |
|----------|------------|
| Bump API | `contents: write`, `pull-requests: write` |
| Bump Web | `contents: write`, `pull-requests: write` |
| Create Release Tag | `contents: write` |
| Publish Artifacts | `contents: write`, `packages: write` |
| Documentation | `contents: read`, `pages: write`, `id-token: write` |

## Key Integrations

- **[orhun/git-cliff-action](https://github.com/orhun/git-cliff-action/)** - Changelog generation from conventional commits
- **[astral-sh/setup-uv](https://github.com/astral-sh/setup-uv/)** - Python package manager and version tool
- **[docker/metadata-action](https://github.com/docker/metadata-action/)** - Docker image tagging (version and latest)
- **[softprops/action-gh-release](https://github.com/softprops/action-gh-release/)** - GitHub Release creation
- **[zensical](https://github.com/mkdocs/zensical)** - Documentation site builder

## Concurrency Controls

The Bump API workflow uses concurrency group `release-api` and the Bump Web workflow uses concurrency group `release-web`, both with `cancel-in-progress: false`, to prevent overlapping release PR creation within each service.

The other workflows can run in parallel.
