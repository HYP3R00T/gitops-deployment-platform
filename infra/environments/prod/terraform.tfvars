region = "ap-south-1"

cluster_name       = "gitops-prod"
kubernetes_version = "1.35"

vpc_cidr = "10.20.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b",
  "ap-south-1c",
]

private_subnets = [
  "10.20.1.0/24",
  "10.20.2.0/24",
  "10.20.3.0/24",
]

public_subnets = [
  "10.20.101.0/24",
  "10.20.102.0/24",
  "10.20.103.0/24",
]

enable_nat_gateway     = true
single_nat_gateway     = false
one_nat_gateway_per_az = true

enable_irsa = true

endpoint_public_access  = true
endpoint_private_access = true

addons = {
  coredns = {
    most_recent = true
  }
  kube-proxy = {
    most_recent = true
  }
  vpc-cni = {
    most_recent = true
  }
}

compute_config = {
  enabled = false
}

eks_managed_node_groups = {
  default = {
    instance_types = ["m5.large"]
    min_size       = 2
    max_size       = 6
    desired_size   = 3
  }
}

tags = {
  Environment = "prod"
  Project     = "gitops-deployment-platform"
  ManagedBy   = "terraform"
}
