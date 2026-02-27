# Usage in GitHub Actions

This page covers the minimum workflow configuration to use the OIDC role from [infra/identity/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/identity).

## Required Workflow Permissions

```yaml
permissions:
  id-token: write
  contents: read
```

## Configure AWS Credentials

Get role ARN:

```bash
terraform -chdir=infra/identity output role_arn
```

Use it in workflow:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v6
  with:
    role-to-assume: <role_arn>
    aws-region: ap-south-1
```

## Repository Example

See [.github/workflows/oidc-test.yml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/oidc-test.yml).

## Related

- [Applying](applying.md)
- [Policy Attachment](policy-attachment.md)
- [Troubleshooting](troubleshooting.md)
