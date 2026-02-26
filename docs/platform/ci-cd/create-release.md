# Create Release Tag Workflow

**File:** [`.github/workflows/create-tag.yml`](../../.github/workflows/create-tag.yml)

## Purpose

Automatically creates and pushes a Git tag when a release PR is merged to `main`, marking the version in the repository history.

## How It Works

Triggers on `pull_request` closed event to `main` when **all three** conditions are true:

1. The PR was **merged** (not just closed)
2. It has the **`release` label**
3. The source branch matches **`release/*`** pattern

## Steps

1. **Checkout main at merge commit** with full history (`fetch-depth: 0`)
2. **Parse tag from branch name**
   - Strips `release/` prefix from branch name
   - Example: `release/api-v1.2.3` → tag `api-v1.2.3`
3. **Configure git user** as `github-actions[bot]`
4. **Create and push tag** to origin
   - Command: `git tag <TAG>` → `git push origin <TAG>`

## Outputs

| Output | Value |
|--------|-------|
| `tag` | Version tag extracted from branch (e.g., `api-v1.2.3`) |

## Permissions Required

- `contents: write` — Create and push Git tags

## Trigger Conditions

All conditions must be true:

```yaml
github.event.pull_request.merged == true        # PR was merged
contains(labels, 'release')                      # Has release label
startsWith(branch, 'release/')                   # Branch pattern
```

This ensures the tag only gets created when a release PR is intentionally merged, not on accidental closes or non-release PRs.

## Branch Naming Convention

Release branches must follow this pattern:

- **API:** `release/api-v<MAJOR>.<MINOR>.<PATCH>`
    - Example: `release/api-v1.2.3`
- **Web:** `release/web-v<MAJOR>.<MINOR>.<PATCH>`
    - Example: `release/web-v2.0.0`

The tag created will exactly match the branch name minus the `release/` prefix.

## Related Workflows

- **Previous:** [`Bump API`](bump-api.md) creates the release PR with `release` label
- **Next:** [`Publish Artifacts`](publish-artifacts.md) uses the same merge event to build and publish

Both workflows are triggered by the same merged PR, but run independently (tag is created alongside artifact publishing, not before it).
