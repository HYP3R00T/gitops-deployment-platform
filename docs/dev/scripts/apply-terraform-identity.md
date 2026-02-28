# apply-terraform-identity.sh

Applies the Terraform identity stack for GitHub OIDC and IAM roles.

## Purpose

Runs a guided Terraform workflow for `infra/identity` so you do not need to manually change directories or remember command order.

## What It Does

1. Validates prerequisites:
   - `terraform` CLI
   - `aws` CLI
   - Valid AWS credentials (`aws sts get-caller-identity`)
2. Runs Terraform in `infra/identity`:
   - `terraform init -upgrade`
   - `terraform validate`
   - `terraform plan`
3. Prompts for confirmation before apply
4. Runs `terraform apply`
5. Prints identity outputs (OIDC provider and role ARNs)

## Usage

```bash
./scripts/apply-terraform-identity.sh
```

## Notes

- Safe to run repeatedly; Terraform handles drift and idempotency.
- If you answer `n` at the prompt, no changes are applied.
- This script targets the shared identity stack in `infra/identity`.

## Related

- [Terraform GitHub OIDC Identity](../../platform/terraform/github-oidc-identity/index.md)
- [Mise Configuration](../mise/index.md)
