# GitHub OIDC Provider for AWS
# This allows GitHub Actions to authenticate with AWS using OIDC

# Create the OIDC Provider using terraform-aws-modules
module "iam_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "6.4.0"

  url = "https://token.actions.githubusercontent.com"

  tags = var.tags
}
