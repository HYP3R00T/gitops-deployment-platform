# How Lock Files Work

**Audience:** Developers, infrastructure operators
**Question:** How does version pinning affect my daily workflow?

## In Development

```bash
terraform init
```

This command reads `.terraform.lock.hcl` and uses **only** the pinned versions listed there. It does not check for newer versions.

## In CI/CD Pipelines

GitHub Actions workflows run:

```bash
terraform init
```

Same behavior as development: uses pinned versions only. The `-upgrade` flag is never used.

See the [dev deployment workflow](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/deploy-dev-environment.yml) for the actual pipeline configuration.

## Lock File Changes

The `.terraform.lock.hcl` file changes only when:

1. You run `terraform init -upgrade` **locally** (intentional upgrade)
2. You add a new provider or module
3. Terraform detects corrupted cached files

Lock files in the main branch stay stable. CI/CD pipelines never update them.

## What This Means

- All developers use the same provider versions as CI/CD
- No surprises where "it works locally but fails in production"
- Version drift is impossible
