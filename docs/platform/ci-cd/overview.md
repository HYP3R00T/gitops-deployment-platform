# Pipeline Overview

The CI/CD pipeline is a **four-stage automated release workflow** that transforms commits into versioned artifacts and deployed documentation.

## Pipeline Stages

### Stage 1: Trigger → Prepare Release PR

**Workflow:** [`Bump API`](.github/workflows/bump-api.yml)

When code is committed to `services/api/**`, the Bump API workflow automatically:

- Bumps the version in `services/api/pyproject.toml` (patch/minor/major)
- Generates a changelog using `git-cliff` from commits matching `api-v*` tag pattern
- Creates a release PR with the changelog as the PR body, labeled `release`
- Awaits manual review and merge

The workflow can also be manually triggered via `workflow_dispatch` with a version bump input.

**Guard:** The workflow skips if the commit is a release PR merge (detected by `release/api-v` in commit message), preventing automatic re-triggering.

### Stage 2: Merge → Create Git Tag

**Workflow:** [`Create Release Tag`](.github/workflows/create-tag.yml)

When a PR with the `release` label and a branch matching `release/*` is merged to `main`:

- Parses the tag name from the branch (e.g., `release/api-v1.2.3` → `api-v1.2.3`)
- Configures git user as `github-actions[bot]`
- Creates and pushes the tag to origin

This tag serves as the version marker and triggers downstream workflows.

### Stage 3: Tag → Build & Publish

**Workflow:** [`Publish Artifacts`](.github/workflows/docker-publish.yml)

Triggered by the same conditions as Stage 2 (merged release PR):

- Extracts service name and version from the branch name
- Validates the service directory exists (e.g., `services/api`)
- Logs into GitHub Container Registry (GHCR)
- Builds and pushes Docker image with version tag and `latest` tag
- Creates a GitHub Release with the service changelog

**Output:** Published Docker image at `ghcr.io/<owner>/<service>:v<version>` and GitHub Release.

### Stage 4: Push (docs) → Deploy Docs

**Workflow:** [`Documentation`](.github/workflows/docs.yml)

Triggered on push to `main` when `docs/**` or `zensical.toml` changes:

- Checks out Python 3.14 runtime
- Installs `zensical` (custom doc builder)
- Builds the site with `--clean` flag
- Uploads artifact and deploys to GitHub Pages

Also supports manual trigger via `workflow_dispatch`.

## Workflow Dependencies

```sh
Code Commit (services/api/**)
         ↓
    [Bump API] → creates release/api-vX.Y.Z PR
         ↓
    PR Merge (with "release" label)
         ↓
   [Create Release Tag] → pushes api-vX.Y.Z tag
         ↓
  [Publish Artifacts] → builds docker & release
```

Docs deployment is independent:

```sh
Docs Commit (docs/**)
         ↓
[Documentation] → builds site, deploys to Pages
```

## Permissions Model

Each workflow requests minimal permissions required:

| Workflow | Permissions |
|----------|------------|
| Bump API | `contents: write`, `pull-requests: write` |
| Create Release Tag | `contents: write` |
| Publish Artifacts | `contents: write`, `packages: write` |
| Documentation | `contents: read`, `pages: write`, `id-token: write` |

## Key Integrations

- **[orhun/git-cliff-action](https://github.com/orhun/git-cliff-action/)** — Changelog generation from conventional commits
- **[astral-sh/setup-uv](https://github.com/astral-sh/setup-uv/)** — Python package manager and version tool
- **[docker/metadata-action](https://github.com/docker/metadata-action/)** — Docker image tagging (version and latest)
- **[softprops/action-gh-release](https://github.com/softprops/action-gh-release/)** — GitHub Release creation
- **[zensical](https://github.com/mkdocs/zensical)** — Documentation site builder

## Concurrency Controls

The Bump API workflow uses a concurrency group (`release-api`) with `cancel-in-progress: false` to prevent overlapping release PR creation.

The other workflows can run in parallel.
