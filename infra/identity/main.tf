# GitHub OIDC Provider for AWS
# This allows GitHub Actions to authenticate with AWS using OIDC

# Create the OIDC Provider using terraform-aws-modules
module "iam_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "6.4.0"

  url = "https://token.actions.githubusercontent.com"

  tags = var.tags
}

# Build the OIDC wildcard subjects for GitHub Actions
# Allows all repositories in the organization if no specific repos are provided
# Otherwise, restricts to the specified repositories
locals {
  # If no repositories specified, allow all repos in the organization
  oidc_wildcard_subjects = length(var.github_repositories) > 0 ? [
    for repo in var.github_repositories :
    "${var.github_org}/${repo}:*"
  ] : ["${var.github_org}/*"]
}

# GitHub OIDC IAM Role using terraform-aws-modules
module "github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.4.0"

  name = var.role_name

  description          = var.role_description
  max_session_duration = var.max_session_duration

  # Enable generic OIDC authentication with GitHub provider
  enable_oidc            = true
  oidc_provider_urls     = [module.iam_oidc_provider.url]
  oidc_wildcard_subjects = local.oidc_wildcard_subjects

  tags = var.tags
}
