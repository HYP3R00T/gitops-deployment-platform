region = "ap-south-1"

cluster_name       = "gitops-dev"
kubernetes_version = "1.35"

vpc_cidr = "10.10.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b",
]

private_subnets = [
  "10.10.1.0/24",
  "10.10.2.0/24",
]

public_subnets = [
  "10.10.101.0/24",
  "10.10.102.0/24",
]

enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false

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
    instance_types = ["t3.medium"]
    min_size       = 1
    max_size       = 3
    desired_size   = 2
  }
}

tags = {
  Environment = "dev"
  Project     = "gitops-deployment-platform"
  ManagedBy   = "terraform"
}
