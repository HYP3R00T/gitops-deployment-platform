# Applying the Identity Module

This page describes the apply flow for [infra/identity/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/identity).

## Prerequisites

1. Backend bootstrap has been applied: [backend-bootstrap/applying.md](../backend-bootstrap/applying.md)
2. AWS credentials are available in your environment

## 1) Set Backend Bucket

Update [infra/identity/backend.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/backend.tf) so `bucket` matches bootstrap output.

```bash
terraform -chdir=infra/bootstrap output s3_bucket_name
```

## 2) Set Identity Inputs

Edit [infra/identity/terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/terraform.tfvars):

- `region`
- `github_org`
- `github_repositories`
- role and tag fields if required

## 3) Apply

```bash
terraform -chdir=infra/identity init
terraform -chdir=infra/identity validate
terraform -chdir=infra/identity plan
terraform -chdir=infra/identity apply
```

## 4) Capture Outputs

```bash
terraform -chdir=infra/identity output
```

Use `role_arn` in GitHub Actions workflows.

## Next

- [Usage in GitHub Actions](usage.md)
- [Policy Attachment](policy-attachment.md)
- [Troubleshooting](troubleshooting.md)
