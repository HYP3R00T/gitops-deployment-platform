output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.iam_oidc_provider.arn
}

output "oidc_provider_url" {
  description = "URL of the GitHub OIDC provider"
  value       = module.iam_oidc_provider.url
}

output "role_arn" {
  description = "ARN of the GitHub OIDC IAM role"
  value       = module.github_oidc_role.arn
}

output "role_name" {
  description = "Name of the GitHub OIDC IAM role"
  value       = module.github_oidc_role.name
}

output "role_id" {
  description = "ID of the GitHub OIDC IAM role"
  value       = module.github_oidc_role.unique_id
}

output "github_actions_configuration" {
  description = "GitHub Actions configuration details"
  value = {
    role_arn          = module.github_oidc_role.arn
    oidc_provider_url = module.iam_oidc_provider.url
    aws_region        = var.region
    github_org        = var.github_org
    allowed_repos     = length(var.github_repositories) > 0 ? var.github_repositories : ["*"]
  }
}
