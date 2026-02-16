# Backend configuration for the bootstrap module
#
# This bootstrap module uses LOCAL state because:
# - It creates the S3 bucket used for remote state
# - Using remote state here would create a chicken-and-egg problem
# - Bootstrap is a one-off operation that doesn't require remote state
#
# DO NOT add a backend configuration to this file.
#
# For other Terraform modules that should use the remote backend:
# After applying this bootstrap, use the output 'backend_config' to configure
# your other modules to use the S3 backend created here.
#
# Example for other modules:
# terraform {
#   backend "s3" {
#     bucket  = "<s3_bucket_name from output>"
#     key     = "<module-name>/terraform.tfstate"
#     region  = "ap-south-1"
#     encrypt = true
#     use_lockfile = true
#   }
# }
