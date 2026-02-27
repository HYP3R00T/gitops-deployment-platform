# terraform-show-outputs.sh

Shows Terraform outputs for common infrastructure stacks from one command.

## Purpose

Provides a single entry point for `terraform output -json` across the main infrastructure directories so you do not need to navigate into each folder.

## Supported Targets

- `bootstrap` → `infra/bootstrap`
- `identity` → `infra/identity`
- `dev` → `infra/environments/dev`
- `prod` → `infra/environments/prod`

## Usage

Interactive selection:

```bash
./scripts/terraform-show-outputs.sh
```

Direct selection by arguments:

```bash
./scripts/terraform-show-outputs.sh bootstrap
./scripts/terraform-show-outputs.sh identity dev
```

## Output Format

- Uses raw JSON from `terraform output -json`.
- Prints a section header per selected target.

## Notes

- If a stack has no local state yet, the script prints a warning and a suggested apply command.
- Unknown target names exit with an error.

## Related

- [Terraform Backend Bootstrap](../../platform/terraform/backend-bootstrap/index.md)
- [Terraform GitHub OIDC Identity](../../platform/terraform/github-oidc-identity/index.md)
- [Mise Configuration](../mise/index.md)
