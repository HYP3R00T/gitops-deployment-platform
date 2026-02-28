# Troubleshooting

**Audience:** Developers, operators
**Question:** Why is my Terraform behaving unexpectedly?

## Lock File Changed Unexpectedly

**Symptom:** `git status` shows `.terraform.lock.hcl` was modified, but you didn't intend to upgrade.

**Cause:** Someone ran `terraform init -upgrade` and committed it.

**Fix:**

```bash
git fetch origin
git checkout origin/main -- .terraform.lock.hcl
terraform init
```

## Different Versions Locally vs CI/CD

**Symptom:** `terraform plan` succeeds locally but fails in CI/CD pipeline.

**Cause:** Your `.terraform.lock.hcl` differs from the version on main.

**Fix:**

```bash
git fetch origin
git checkout origin/main -- .terraform.lock.hcl
terraform init
```

Then retry your operations with the canonical lock file.

## Need a Different Provider Version

**Symptom:** You need AWS provider 6.35.0 but main branch has 6.34.0.

**Do this:** Follow [Upgrading Providers](upgrading.md) process. Don't manually edit lock files.

**Don't do this:** Hand-edit `.terraform.lock.hcl`. It has hash validation for security.

## Corrupted .terraform Directory

**Symptom:** Strange errors about missing files or modules.

**Fix:**

```bash
rm -rf .terraform
terraform init
```

The `-upgrade` flag is not needed. Init will download the pinned versions.

## Module Not Found

**Symptom:** Error like "module not found" when updating a local module.

**Cause:** `.terraform` cache has old module version.

**Fix:**

```bash
rm -rf .terraform
terraform init
terraform plan
```
