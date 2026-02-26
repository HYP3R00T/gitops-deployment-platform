# Bump API Workflow

**File:** [`.github/workflows/bump-api.yml`](../../.github/workflows/bump-api.yml)

## Purpose

Automatically creates a release pull request when commits are pushed to `services/api/**`, with a bumped version number and auto-generated changelog.

## How It Works

### Automatic Trigger

Fires on `push` to `main` when any file in `services/api/**` changes.

**Guard:** Skips if the commit message contains `release/api-v`, which prevents re-triggering on the release PR merge commit back to `main`.

### Manual Trigger

Invoke via `workflow_dispatch` with options:

- **Bump**: `patch` (default), `minor`, or `major`

## Steps

1. **Checkout repository** with full commit history (`fetch-depth: 0`)
2. **Install uv** (Astral's Python package manager)
3. **Bump version** in `services/api/pyproject.toml` using `uv version --bump <type>`
   - Outputs the new version for downstream steps
4. **Generate changelog** using `git-cliff-action`
   - Reads conventional commits matching `api-v*` tag pattern in `services/api/**`
   - Writes changelog to `services/api/CHANGELOG.md`
5. **Verify changelog** is non-empty (exits with error if missing)
6. **Create release PR** using `peter-evans/create-pull-request`
   - Branch: `release/api-v<VERSION>`
   - Title: `chore(release): api v<VERSION>`
   - Body: Changelog contents
   - Labels: `release`
   - Adds modified files: `pyproject.toml`, `CHANGELOG.md`, `uv.lock`
7. **Ensure PR created** - fails if PR creation was skipped (usually means PR already exists)

## Outputs

| Output | Value |
|--------|-------|
| `new_version` | Bumped version string (e.g., `1.2.3`) |
| `pull-request-number` | PR number (on successful creation) |

## Concurrency

Uses concurrency group `release-api` with `cancel-in-progress: false`, ensuring only one bump-api workflow runs at a time.

## Permissions Required

- `contents: write` — Commit changes to `pyproject.toml`, `CHANGELOG.md`, `uv.lock`
- `pull-requests: write` — Create release PR

## Key Configuration

- **Config file:** `cliff.toml` (project root, for changelog generation)
- **Version file:** `services/api/pyproject.toml`
- **Changelog output:** `services/api/CHANGELOG.md`
- **Tag pattern:** `api-v*` (filters commits for this service's changelog)
- **Default bump:** `patch` (increments patch version on automatic trigger)

## Next Steps

When this workflow creates a release PR:

1. Review the changelog and version bump manually
2. Merge the PR to `main` (ensure the `release` label remains)
3. The [`Create Release Tag`](create-release.md) workflow automatically creates the Git tag
4. The [`Publish Artifacts`](publish-artifacts.md) workflow builds and publishes the Docker image
