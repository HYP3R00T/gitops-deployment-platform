variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
