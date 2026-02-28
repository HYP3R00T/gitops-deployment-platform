variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateways"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT gateway"
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "Create a NAT gateway per AZ"
  type        = bool
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

variable "addons" {
  description = "EKS add-ons configuration"
  type        = map(any)
  default     = {}
}

variable "compute_config" {
  description = "EKS compute configuration (set enabled=false to disable Auto Mode)"
  type        = any
  default     = null
}

variable "eks_managed_node_groups" {
  description = "EKS managed node group configuration"
  type        = map(any)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "access_entries" {
  description = "Map of access entries to add to the cluster"
  type        = map(any)
  default     = {}
}
