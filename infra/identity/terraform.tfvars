region = "ap-south-1"

github_org = "HYP3R00T"

github_repositories = [
  "gitops-deployment-platform"
]

role_name        = "github-oidc-role"
role_description = "Role for GitHub Actions OIDC authentication with AWS"

max_session_duration = 3600

tags = {
  Service     = "identity"
  Environment = "production"
  Terraform   = "true"
  Owner       = "platform-team"
}
