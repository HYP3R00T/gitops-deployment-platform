# EKS Environments

This configuration provisions Amazon EKS clusters for dev and prod environments.

## What Exists

Code lives in:

- [infra/environments/dev/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/environments/dev)
- [infra/environments/prod/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/environments/prod)
- [infra/modules/eks/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules/eks)
- [infra/modules/vpc/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules/vpc)

Current Terraform configuration creates:

- VPC with public and private subnets across multiple availability zones
- NAT gateways for private subnet internet access
- EKS cluster with managed node groups
- EKS add-ons (CoreDNS, kube-proxy, VPC-CNI, pod-identity-agent)
- KMS encryption for cluster secrets
- IAM OIDC provider for Kubernetes service accounts (IRSA)
- EKS access entries for cluster access control

See environment files: [dev/main.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/main.tf), [prod/main.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/prod/main.tf).

## Dependencies

Each environment uses an S3 backend in [backend.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/backend.tf), so backend bootstrap must be complete first.

EKS access entries reference IAM roles created by the identity module.

See:

- [Terraform Backend Bootstrap](../backend-bootstrap/index.md)
- [GitHub OIDC Identity](../github-oidc-identity/index.md)

## Current Environments

| Attribute | Dev | Prod |
|-----------|-----|------|
| **Region** | ap-south-1 | ap-south-1 |
| **Cluster Name** | gitops-dev | gitops-prod |
| **Kubernetes Version** | 1.35 | 1.35 |
| **VPC CIDR** | 10.10.0.0/16 | 10.20.0.0/16 |
| **Availability Zones** | 2 (ap-south-1a, ap-south-1b) | 3 (ap-south-1a, ap-south-1b, ap-south-1c) |
| **NAT Gateway Strategy** | Single shared | One per AZ |
| **Node Instance Type** | t3.medium | m5.large |
| **Node Count** | 1-3 (desired: 2) | 2-6 (desired: 3) |

Configuration in [dev/terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/terraform.tfvars) and [prod/terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/prod/terraform.tfvars).

## Pages

- [Access Configuration](access-configuration.md) - EKS access entries and cluster access control
- [kubectl Setup](kubectl-setup.md) - Configuring kubectl for EKS clusters
- [Provider Versioning](../provider-versioning/index.md) - Understanding exact version locks
