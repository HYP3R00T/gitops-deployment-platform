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
  eks-pod-identity-agent = {
    before_compute = true
    most_recent    = true
  }
  kube-proxy = {
    most_recent = true
  }
  vpc-cni = {
    before_compute = true
    most_recent    = true
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

access_entries = {
  hyperoot = {
    principal_arn = "arn:aws:iam::813554192815:user/hyperoot"
    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
  github_oidc_prod = {
    principal_arn = "arn:aws:iam::813554192815:role/github-oidc-prod"
    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}

tags = {
  Environment = "prod"
  Project     = "gitops-deployment-platform"
  ManagedBy   = "terraform"
}
