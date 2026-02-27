terraform {
  backend "s3" {
    bucket       = "gitops-tfstate-6a95bb4d"
    key          = "identity/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
