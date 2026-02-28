module "vpc" {
  source = "../../modules/vpc"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  cluster_name = var.cluster_name
  tags         = var.tags
}

module "eks" {
  source = "../../modules/eks"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = var.enable_irsa

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access

  enable_cluster_creator_admin_permissions = false

  addons = var.addons

  compute_config = var.compute_config

  eks_managed_node_groups = var.eks_managed_node_groups

  access_entries = var.access_entries

  tags = var.tags
}
