# Development IAM Role for GitHub OIDC
# Allows all GitHub Actions from the gitops-deployment-platform repository
resource "aws_iam_role" "github_oidc_dev" {
  name = "github-oidc-dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.iam_oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/gitops-deployment-platform:*"
          }
        }
      }
    ]
  })

  tags = merge(var.tags, { Environment = "dev" })
}

# Production IAM Role for GitHub OIDC
# Restricts to main branch only for production deployments
resource "aws_iam_role" "github_oidc_prod" {
  name = "github-oidc-prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.iam_oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/gitops-deployment-platform:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = merge(var.tags, { Environment = "prod" })
}

# Attach development policy to dev role
resource "aws_iam_role_policy_attachment" "github_oidc_dev_policy" {
  role       = aws_iam_role.github_oidc_dev.name
  policy_arn = aws_iam_policy.terraform_dev_policy.arn
}

# Attach production policy to prod role
resource "aws_iam_role_policy_attachment" "github_oidc_prod_policy" {
  role       = aws_iam_role.github_oidc_prod.name
  policy_arn = aws_iam_policy.terraform_prod_policy.arn
}
