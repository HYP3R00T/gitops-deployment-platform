variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repositories" {
  description = "List of GitHub repository names allowed to use this OIDC provider"
  type        = list(string)
  default     = []
}

variable "role_name" {
  description = "Name of the IAM role for GitHub OIDC"
  type        = string
  default     = "github-oidc-role"
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Role for GitHub Actions OIDC authentication with AWS"
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
