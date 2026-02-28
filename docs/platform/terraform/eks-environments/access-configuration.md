# EKS Access Configuration

EKS uses access entries to map IAM identities to Kubernetes permissions.

## Overview

EKS access entries control who can authenticate to the Kubernetes API server. Each entry associates an IAM principal (user or role) with an EKS cluster access policy.

This replaces the older `aws-auth` ConfigMap approach with a native AWS API.

## Current Configuration

Access entries are defined in [dev/terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/terraform.tfvars) and [prod/terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/prod/terraform.tfvars).

Dev example:

```terraform
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
  github_oidc_dev = {
    principal_arn = "arn:aws:iam::813554192815:role/github-oidc-dev"
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
```

Prod uses `github-oidc-prod` instead of `github-oidc-dev`.

## Access Entry Types

### IAM User (hyperoot)

- **Principal**: `arn:aws:iam::813554192815:user/hyperoot`
- **Purpose**: Manual cluster administration
- **Use Case**: Running kubectl commands from local development environment
- **Required**: Yes, for developers to access clusters

### GitHub OIDC Roles

- **Principals**: `github-oidc-dev`, `github-oidc-prod`
- **Purpose**: CI/CD automation
- **Use Case**: GitHub Actions workflows deploying to clusters
- **Required**: Yes, for automated deployments

These roles are defined in [infra/identity/roles.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/roles.tf). See [GitHub OIDC Identity](../github-oidc-identity/index.md).

## Access Policy

All entries use `AmazonEKSClusterAdminPolicy` with cluster-wide scope.

This AWS-managed policy grants:

- Full Kubernetes API access
- All namespaces
- All resource types
- All operations (get, list, create, update, delete)

Alternative policies exist for read-only or namespace-scoped access. See [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html).

## Explicit vs Automatic Access

The configuration sets `enable_cluster_creator_admin_permissions = false` in [dev/main.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/main.tf) and [prod/main.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/prod/main.tf).

This disables automatic admin access for whoever runs Terraform. All cluster access is explicitly declared in `access_entries`.

Benefits:

- Predictable: Access doesn't change based on who runs Terraform
- Auditable: All access visible in version control
- CI/CD-friendly: GitHub Actions gets explicit access, not automatic

## Adding New Identities

To grant cluster access to another IAM user or role:

1. Add entry to `access_entries` in [terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/terraform.tfvars)
2. Run `terraform plan` to preview
3. Run `terraform apply` to create access entry
4. New identity can immediately run `aws eks update-kubeconfig` and use kubectl

The module variable is defined in [modules/eks/variables.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/modules/eks/variables.tf).
