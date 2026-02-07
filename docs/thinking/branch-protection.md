# Branch Protection for `main`: Design, Rationale, and Current State

This document describes the **branch protection rules currently enforced on `main`**, why they exist, and why certain controls are intentionally *not* enabled yet.

The configuration described here is **not aspirational**.
It reflects the **exact active ruleset** applied to the repository, exported directly from GitHub and treated as the **source of truth**. :contentReference[oaicite:0]{index=0}

## Purpose of Branch Protection

Branch protection exists to shift `main` from a writable workspace into a **stable integration boundary**.

Once enabled, `main` is no longer a place where work happens directly.
It becomes a place where **reviewed, intentional change arrives**.

The goal is not restriction for its own sake, but predictability:

- every change has context
- every change has review
- every change leaves an audit trail

## Scope of the Ruleset

### Target

- **Branch**: `main` (resolved via `~DEFAULT_BRANCH`)
- **Enforcement**: Active
- **Bypass actors**: None

No users, teams, or apps are exempt.
These rules apply uniformly, including to administrators.

This avoids silent exceptions and ensures governance is explicit rather than role-based.

## Enabled Rules (What Is Enforced)

### 1. Branch Deletion Is Blocked

**Rule:** `deletion`

Deletion of `main` is prohibited.

Rationale:

- `main` represents the continuity of the project
- accidental deletion is unrecoverable without disruption
- no valid workflow depends on deleting the default branch

This is a safety rail, not a workflow constraint.

## 2. Force Pushes Are Blocked

**Rule:** `non_fast_forward`

Force pushes to `main` are disallowed.

Rationale:

- force pushes rewrite history
- rewritten history breaks trust in past decisions
- shared branches must preserve continuity

All history on `main` is append-only.

If history must ever be rewritten, the ruleset itself must be consciously disabled — a deliberate, auditable act.

## 3. Pull Requests Are Required for All Changes

**Rule:** `pull_request`

Direct pushes to `main` are not allowed.
All changes must arrive via a pull request from a non-target branch.

This establishes:

- explicit intent
- review as a default, not an exception
- a stable point for discussion and automation

## Pull Request Requirements (Detailed)

The following constraints apply to every pull request targeting `main`.

## Required Approvals: **1**

At least one approving review is required before merge.

Why one:

- review is about catching blind spots, not building consensus
- the project is currently small and focused
- GitHub does not allow self-approval

This requirement can be increased later as contributor count grows.

## Stale Approvals Are Dismissed on New Commits

If new commits are pushed after approval, the approval is invalidated.

This ensures:

- approvals apply to the code that is actually merged
- late changes are always reviewed
- timing loopholes are closed

## Code Owner Review Is Required

If a pull request modifies files with designated owners, an owner must approve.

This activates the existing `CODEOWNERS` file as an enforcement mechanism, not just documentation.

It encodes responsibility structurally and scales naturally as the project grows.

## Approval of the Most Recent Push Is Required

The final reviewable state of the pull request must be explicitly approved.

This prevents edge cases where:

- approval applies to an earlier state
- the final change lands without explicit sign-off

## All Review Conversations Must Be Resolved

Pull requests cannot be merged with unresolved review threads.

Rationale:

- unresolved discussion is unresolved thinking
- every comment must be addressed, deferred explicitly, or rejected consciously
- decisions should not disappear into history by accident

This is especially important in documentation and architecture-heavy work.

## Allowed Merge Methods

### Enabled

- **Merge commits**
- **Squash merges**

### Disabled

- **Rebase merges**

#### Why merge commits are allowed

- preserve decision boundaries
- keep PR context aligned with history
- make intent visible in the commit graph

#### Why squash merges are allowed

- useful for small or noisy PRs
- produce clean, atomic history when intermediate steps do not matter
- treat the PR itself as the unit of meaning

#### Why rebase merges are disabled

Rebase merging rewrites history so that the pull request appears never to have existed.

This:

- detaches review context from commits
- flattens conceptual changes into unrelated steps
- optimizes for visual neatness over historical truth

For a repository that values reasoning and traceability, this trade-off is not acceptable.

History should optimize for **understanding past decisions**, not for producing a straight line.

## What Is Intentionally Not Enforced (Yet)

The following controls are absent by design, not omission:

- signed commits
- deployment success requirements
- code scanning gates
- code quality thresholds
- reviewer team enforcement
- linear history enforcement

These controls become meaningful only once:

- services exist
- infrastructure is present
- contributor count increases
- automated signal is reliable

Introducing them earlier would add friction without reducing real risk.

## Why These Rules Were Applied Now (and Not Earlier)

Branch protection was introduced **after**:

- development environment stabilization
- documentation structure finalization
- contribution hygiene setup
- automation groundwork

Before this point, the cost of unreviewed change was low.
After this point, the cost of accidental change exceeds the cost of review.

Branch protection follows system maturity — it does not precede it.
The following JSON is a **direct export** of the branch protection ruleset currently applied to the repository’s default branch.

This configuration is treated as **authoritative**.

- The prose in this document is derived from this file
- Any future change to branch protection must update both:
  - the ruleset itself
  - this embedded source of truth

No interpretation is applied inside the block.
If the JSON and the explanation ever diverge, the JSON wins.

```json
{
  "id": 12555375,
  "name": "protect-main",
  "target": "branch",
  "source_type": "Repository",
  "source": "HYP3R00T/gitops-deployment-platform",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "exclude": [],
      "include": [
        "~DEFAULT_BRANCH"
      ]
    }
  },
  "rules": [
    {
      "type": "deletion"
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "required_reviewers": [],
        "require_code_owner_review": true,
        "require_last_push_approval": true,
        "required_review_thread_resolution": true,
        "allowed_merge_methods": [
          "merge",
          "squash"
        ]
      }
    }
  ],
  "bypass_actors": []
}
```

## Summary

With this ruleset in place, `main` is now:

- protected from direct mutation
- resistant to history corruption
- review-driven by default
- documented through its own change history

The configuration is intentionally minimal, enforceable, and future-proof.

As the system evolves, additional controls may be layered on — but only when the system earns them.

This document should be updated **only when the ruleset itself changes**, and always derived from the exported configuration, not memory or assumption.
