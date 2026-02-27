locals {
  cluster_tag = var.cluster_name != "" ? {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } : {}

  public_role_tag = {
    "kubernetes.io/role/elb" = "1"
  }

  private_role_tag = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = var.tags

  public_subnet_tags = merge(
    local.cluster_tag,
    local.public_role_tag,
    var.public_subnet_tags
  )

  private_subnet_tags = merge(
    local.cluster_tag,
    local.private_role_tag,
    var.private_subnet_tags
  )
}
