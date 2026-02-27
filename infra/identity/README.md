# GitHub OIDC Identity Provider for AWS

This Terraform configuration sets up an AWS IAM identity provider for GitHub Actions using OpenID Connect (OIDC). This allows your GitHub Actions workflows to authenticate with AWS without storing AWS credentials.

## Overview

The configuration creates:

- An AWS IAM OIDC Identity Provider that trusts GitHub's token issuer
- An IAM role that GitHub Actions can assume
- Support for scoping access to specific repositories or allowing all repositories in your GitHub organization

## Prerequisites

1. An AWS account
2. Your GitHub organization name
3. Terraform >= 1.0
4. AWS provider >= 6.0

## Usage

### Basic Setup

1. Create a `terraform.tfvars` file in this directory:

```hcl
region         = "us-east-1"
github_org     = "your-github-org"
github_repositories = [
  "your-repo-1",
  "your-repo-2"
]

tags = {
  Environment = "production"
  Terraform   = "true"
}
```

1. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

### Configuration Options

#### Allow All Repositories

To grant access to all repositories in your organization:

```hcl
github_org     = "your-github-org"
# Leave github_repositories empty to allow all repos
github_repositories = []
```

#### Specific Repositories Only

To grant access only to specific repositories:

```hcl
github_org     = "your-github-org"
github_repositories = [
  "gitops-deployment-platform",
  "another-repo"
]
```

#### Custom Role Configuration

```hcl
role_name       = "my-custom-oidc-role"
role_description = "Custom OIDC role for my organization"
max_session_duration = 7200  # 2 hours
```

## GitHub Actions Usage

After applying this configuration, use the role in your GitHub Actions workflows:

```yaml
name: Deploy with AWS

on:
  push:
    branches:
      - main

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/github-oidc-role
          aws-region: us-east-1

      - name: Deploy
        run: |
          aws s3 ls
          # Your deployment commands here
```

## Important Notes

- Ensure `permissions.id-token: write` is set in your workflow
- Store the role ARN from Terraform outputs for use in your workflows
- The OIDC provider URL is fixed to `https://token.actions.githubusercontent.com`
- GitHub OIDC tokens are short-lived (default 15 minutes)

## Outputs

After applying, you'll have:

- `oidc_provider_arn` - ARN of the GitHub OIDC provider
- `role_arn` - ARN of the IAM role to use in workflows
- `role_name` - Name of the IAM role
- `github_actions_configuration` - Summary of configuration details

## Security Considerations

1. **Least Privilege**: Always specify `github_repositories` to restrict which repositories can use this role
2. **Trust Relationship**: The role only trusts GitHub's OIDC provider (`https://token.actions.githubusercontent.com`)
3. **Session Duration**: Adjust `max_session_duration` based on your deployment needs
4. **Permissions**: Attach appropriate IAM policies to the role for your use case

## Adding Permissions to the Role

The role is created without inline policies. Attach policies using:

```hcl
resource "aws_iam_role_policy_attachment" "github_oidc_policy" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/your-policy"
}
```

Or create a separate policy module in the environments configuration.

## References

- [GitHub Actions OIDC Documentation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [AWS IAM OIDC Provider Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html)
- [AWS Actions Configure AWS Credentials Action](https://github.com/aws-actions/configure-aws-credentials)
