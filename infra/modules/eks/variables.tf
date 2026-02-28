variable "name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS nodes"
  type        = list(string)
}

variable "enable_irsa" {
  description = "Enable IAM roles for service accounts (IRSA)"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Expose EKS API publicly"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Expose EKS API privately"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Add cluster creator as an administrator via cluster access entry"
  type        = bool
  default     = false
}

variable "addons" {
  description = "EKS add-ons configuration"
  type        = map(any)
  default     = {}
}

variable "compute_config" {
  description = "EKS compute configuration for Auto Mode (set enabled=false to disable)"
  type        = any
  default     = null
}

variable "eks_managed_node_groups" {
  description = "EKS managed node group configuration"
  type        = map(any)
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}
}

variable "access_entries" {
  description = "Map of access entries to add to the cluster"
  type        = map(any)
  default     = {}
}
