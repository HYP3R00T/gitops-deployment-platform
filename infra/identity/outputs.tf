output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.iam_oidc_provider.arn
}

output "oidc_provider_url" {
  description = "URL of the GitHub OIDC provider"
  value       = module.iam_oidc_provider.url
}

output "dev_role_arn" {
  description = "ARN of the development GitHub OIDC IAM role"
  value       = aws_iam_role.github_oidc_dev.arn
}

output "prod_role_arn" {
  description = "ARN of the production GitHub OIDC IAM role (main branch only)"
  value       = aws_iam_role.github_oidc_prod.arn
}
