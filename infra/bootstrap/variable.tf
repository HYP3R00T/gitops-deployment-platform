variable "region" {
  description = "AWS region for the backend resources"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name. A random suffix will be appended for uniqueness."
  type        = string
  default     = "gitops-tfstate"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "gitops-deployment-platform"
    ManagedBy = "terraform"
  }
}
