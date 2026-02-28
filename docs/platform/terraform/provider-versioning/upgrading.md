# Upgrading Providers

**Audience:** Infrastructure maintainers, release managers
**Question:** How do I update to a newer provider version?

## When to Upgrade

Quarterly review of provider releases:

- AWS Provider: <https://github.com/hashicorp/terraform-provider-aws/releases>
- Terraform: <https://github.com/hashicorp/terraform/releases>

## Process

### 1. Create Feature Branch

```bash
git checkout -b chore/update-aws-provider-6.35
```

### 2. Update Locally

```bash
cd infra/environments/dev
terraform init -upgrade
```

This updates `.terraform.lock.hcl` to the latest version matching your constraints. With exact pins (`= 6.34.0`), this would fail unless you first update `versions.tf`.

### 3. Commit Lock File Changes

```bash
git add .terraform.lock.hcl

git commit -m "chore: update AWS provider to 6.35.0

Reviewed changelog for breaking changes: none
Tested with dev environment: plan succeeds
"
```

### 4. Create Pull Request

- Link to provider changelog
- Document any breaking changes reviewed
- Request review from team

### 5. Merge

After approval and CI/CD validation, merge to main. All future deployments use the new version. Lock file stabilizes again.

## Testing

Before merging, test in dev:

```bash
# With new version from lock file
terraform plan
terraform apply
```

Verify infrastructure behaves as expected.

## Rollback

If a provider version causes issues:

```bash
git revert <commit-hash>
git push
```

Previous lock file is restored. New deployments use previous version.
