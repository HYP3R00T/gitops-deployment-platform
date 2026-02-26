# Bump Web Workflow

**File:** [`.github/workflows/bump-web.yml`](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/bump-web.yml)

## Purpose

Automatically creates a release pull request when commits are pushed to `services/web/**`, with a bumped version number and auto-generated changelog.

## How It Works

### Automatic Trigger

Fires on `push` to `main` when any file in `services/web/**` changes.

**Guard:** Skips if the commit message contains `release/web-v`, which prevents re-triggering on the release PR merge commit back to `main`.

### Manual Trigger

Invoke via `workflow_dispatch` with options:

- **Bump**: `patch` (default), `minor`, or `major`

## Steps

1. **Checkout repository** with full commit history (`fetch-depth: 0`)
2. **Setup Node.js** using the version specified in `services/web/package.json`
3. **Bump version** in `services/web/package.json` using `npm version <type>`
   - Outputs the new version for downstream steps
4. **Generate changelog** using `git-cliff-action`
   - Reads conventional commits matching `web-v*` tag pattern in `services/web/**`
   - Writes changelog to `services/web/CHANGELOG.md`
5. **Verify changelog** is non-empty (exits with error if missing)
6. **Create release PR** using `peter-evans/create-pull-request`
   - Branch: `release/web-v<VERSION>`
   - Title: `chore(release): web v<VERSION>`
   - Body: Changelog contents
   - Labels: `release`
   - Adds modified files: `package.json`, `pnpm-lock.yaml`, `CHANGELOG.md`
7. **Ensure PR created** - fails if PR creation was skipped (usually means PR already exists)

## Outputs

| Output | Value |
|--------|-------|
| `new_version` | Bumped version string (e.g., `1.2.3`) |
| `pull-request-number` | PR number (on successful creation) |

## Concurrency

Uses concurrency group `release-web` with `cancel-in-progress: false`, ensuring only one bump-web workflow runs at a time.

## Permissions Required

- `contents: write` — Commit changes to `package.json`, `CHANGELOG.md`, `pnpm-lock.yaml`
- `pull-requests: write` — Create release PR

## Key Configuration

- **Config file:** `cliff.toml` (project root, for changelog generation)
- **Version file:** `services/web/package.json`
- **Changelog output:** `services/web/CHANGELOG.md`
- **Lock file:** `pnpm-lock.yaml` (updated by `npm version`)
- **Tag pattern:** `web-v*` (filters commits for this service's changelog)
- **Default bump:** `patch` (increments patch version on automatic trigger)

## Next Steps

When this workflow creates a release PR:

1. Review the changelog and version bump manually
2. Merge the PR to `main` (ensure the `release` label remains)
3. The [`Create Release Tag`](create-release.md) workflow automatically creates the Git tag
4. The [`Publish Artifacts`](publish-artifacts.md) workflow builds and publishes the Docker image
