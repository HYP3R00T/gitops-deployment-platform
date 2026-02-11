# Intentional Constraints

This project defines success by what it **refuses** to do. To maintain sharp focus on DevOps maturity, the following are intentionally excluded.

???+ note "Purposeful restraint"
	Every "no" documented below is a conscious decision meant to keep the narrative focused on platform delivery. Adding missing features without a clear need dilutes the story.

## What the Platform Does NOT Include

- **No Imperative Deployments:** Direct cluster manipulation (e.g., `kubectl apply`) is forbidden in CI/CD. All changes flow through GitOps reconciliation.
- **No Persistent Databases:** The services are stateless to focus on deployment mechanics, not application complexity.
- **No User Authentication:** No "product" features are built to avoid distracting from the infrastructure narrative.
- **No Complex Frontends:** The UI exists solely as an **operational status surface** to visualize version metadata and health.
- **No Hidden Dependencies:** All tools and versions are pinned and explicit in version-controlled manifests.
- **No Vendor Lock-in (Logic):** The architectural _patterns_ remain portable, even if specific implementations use AWS, Terraform, or GitHub Actions.

## Why These Constraints Exist

Restraint is a deliberate design choice. Without these boundaries, the scope explodes and the core DevOps narrative gets buried under application complexity.

By saying "no" to features, we say "yes" to clarity.
