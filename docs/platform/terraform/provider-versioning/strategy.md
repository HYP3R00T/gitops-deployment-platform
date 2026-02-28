# Why Exact Version Pinning?

**Audience:** Architects, decision-makers, code reviewers
**Question:** Why does this project pin provider versions instead of using loose constraints?

## Problem: Version Drift in CI/CD

With loose version constraints (`~> 6.0`), Terraform's version selection becomes unpredictable across environments:

1. Developer locally: `terraform init -upgrade` → AWS provider 6.34.0 locked
2. CI/CD pipeline: `terraform init -upgrade` → AWS provider 6.35.0 released yesterday
3. `.terraform.lock.hcl` changes without review
4. Code applies with untested provider version
5. Production behavior differs from development

Result: **Hidden, unreviewed infrastructure changes**.

## Solution: Exact Pinning

Pin each provider to an exact version:

- `version = "= 6.34.0"` (only 6.34.0, never 6.35.0)
- Lock files become immutable during pipeline runs
- Version upgrades require explicit PR review

Result: **Deterministic, auditable infrastructure**.

## Trade-Off

**Benefit:** Reproducibility and safety across all environments
**Cost:** Manual effort to review and upgrade providers quarterly

This is an acceptable trade-off for production infrastructure.
