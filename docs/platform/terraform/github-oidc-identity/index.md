# GitHub OIDC Identity Provider

This module configures AWS IAM resources so GitHub Actions can authenticate to AWS with OIDC.

## What Exists

Code lives in [infra/identity/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/identity).

Current Terraform configuration creates:

- IAM OIDC provider for `https://token.actions.githubusercontent.com`
- IAM role configured for OIDC trust
- Trust scope built from `github_org` and optional `github_repositories`

See [main.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/main.tf) and [outputs.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/outputs.tf).

## Dependency

This module uses an S3 backend in [backend.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/backend.tf), so backend bootstrap must be complete first.

See [Terraform Backend Bootstrap](../backend-bootstrap/index.md).

## Current Inputs

Inputs are defined in [variables.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/variables.tf). The active repository values are in [terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/terraform.tfvars).

## Pages

- [Applying](applying.md)
- [Usage in GitHub Actions](usage.md)
- [Policy Attachment](policy-attachment.md)
- [Troubleshooting](troubleshooting.md)
- [Provider Versioning](../provider-versioning/index.md) - Understanding exact version locks
