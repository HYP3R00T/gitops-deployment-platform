# Branch Protection: Enforced Rules

Branch protection shifts `main` from a writable workspace into a stable integration boundary.

## Scope

- **Branch**: `main` (resolved via `~DEFAULT_BRANCH`)
- **Enforcement**: Active
- **Bypass actors**: None

## Enabled Rules

### Branch Deletion Is Blocked

**Rule:** `deletion`

- `main` represents project continuity
- Accidental deletion is disruptive
- No valid workflow depends on deleting the default branch

### Force Pushes Are Blocked

**Rule:** `non_fast_forward`

- Force pushes rewrite history
- Rewritten history breaks trust in past decisions
- Shared branches must preserve continuity

If history must ever be rewritten, the ruleset must be consciously disabled and re-enabled.

### Pull Requests Are Required

**Rule:** `pull_request`

Direct pushes to `main` are not allowed. All changes arrive via pull request from a non-target branch.

## Pull Request Requirements

### Required Approvals: 0 (Bootstrap Phase)

This is temporary and intentional:

- Single active maintainer
- GitHub does not allow authors to approve their own pull requests
- Requiring approvals without additional reviewers would deadlock merges

Review rules still apply and this will increase once additional reviewers exist.

### Stale Approvals Are Dismissed on New Commits

If approvals are enabled in the future, new commits dismiss prior approvals so reviews apply to the code that is merged.

### Code Owner Review Is Required

Files with designated owners require an owner approval. `CODEOWNERS` is treated as an enforcement mechanism.

### Approval of the Most Recent Push (Disabled)

This rule requires a reviewer other than the author. It is disabled to avoid an unsatisfiable condition in a single-maintainer repo.

### All Review Conversations Must Be Resolved

Pull requests cannot merge with unresolved review threads. Discussions must be addressed or deferred explicitly.

## Allowed Merge Methods

### Enabled

- Merge commits
- Squash merges

### Disabled

- Rebase merges

Rebase merging rewrites history and detaches review context from commits. This repository prioritizes traceability.

## Not Enforced Yet

The following are intentionally absent until the system matures:

- Signed commits
- Deployment success requirements
- Code scanning gates
- Code quality thresholds
- Reviewer team enforcement
- Linear history enforcement

## Why These Rules Were Applied Now

Branch protection was introduced after environment stabilization, documentation structure, and automation groundwork. The cost of accidental change now exceeds the cost of review.
