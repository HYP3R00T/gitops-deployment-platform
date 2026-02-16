output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "region" {
  description = "AWS region where resources are created"
  value       = var.region
}

output "backend_config" {
  description = "Backend configuration snippet for other Terraform modules (uses S3 native locking)"
  value       = <<-EOT
    terraform {
      backend "s3" {
        bucket       = "${aws_s3_bucket.terraform_state.id}"
        key          = "<module-name>/terraform.tfstate"
        region       = "${var.region}"
        encrypt      = true
        use_lockfile = true  # Required to enable S3 native state locking
      }
    }
  EOT
}
