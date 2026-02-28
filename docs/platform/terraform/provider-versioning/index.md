# Provider Versioning

All Terraform providers use exact version pins (e.g., `= 6.34.0`). This ensures consistent behavior across development, CI/CD, and production.

## Current State

**Pinned Provider:**

- AWS Provider: `6.34.0` (in all `infra/*/versions.tf` files)

**Pinned Terraform Binary:**

- GitHub Actions workflow: `1.9.7`

**Terraform Modules:**

- terraform-aws-modules/vpc/aws: `6.6.0`
- terraform-aws-modules/eks/aws: `21.15.1`
- terraform-aws-modules/iam/aws: `6.4.0`

(Module versions are already exact in source declarations.)

## Documentation

- [Why Pinning](strategy.md) - Architectural decision and problem solved
- [How Lock Files Work](how-it-works.md) - Behavior in development and pipelines
- [Upgrading Providers](upgrading.md) - Process and workflow for version updates
- [Troubleshooting](troubleshooting.md) - Common issues and solutions
