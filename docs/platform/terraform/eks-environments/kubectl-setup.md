# kubectl Setup

Configure kubectl to access EKS clusters.

## Prerequisites

AWS CLI configured with credentials for IAM user `hyperoot`.

Verify with:

```bash
aws sts get-caller-identity
```

Expected output shows `UserId`, `Account`, and `Arn` for the `hyperoot` user.

## Configure kubectl for Dev

```bash
aws eks update-kubeconfig --region ap-south-1 --name gitops-dev
```

This updates `~/.kube/config` with cluster connection details and authentication configuration.

Test access:

```bash
kubectl get nodes
```

Expected output shows 2 nodes in Ready state.

## Configure kubectl for Prod

```bash
aws eks update-kubeconfig --region ap-south-1 --name gitops-prod
```

Test access:

```bash
kubectl get nodes
```

Expected output shows 3 nodes in Ready state.

## Switching Between Clusters

List available contexts:

```bash
kubectl config get-contexts
```

Switch to dev:

```bash
kubectl config use-context arn:aws:eks:ap-south-1:813554192815:cluster/gitops-dev
```

Switch to prod:

```bash
kubectl config use-context arn:aws:eks:ap-south-1:813554192815:cluster/gitops-prod
```

Current context shown in `kubectl config get-contexts` with asterisk.

## How Authentication Works

When you run kubectl commands:

1. kubectl reads `~/.kube/config` for cluster endpoint and credentials
2. Config contains exec block calling `aws eks get-token --cluster-name <name>`
3. AWS CLI uses your current IAM credentials (user or assumed role)
4. AWS returns short-lived authentication token (15 minutes)
5. kubectl includes token in HTTPS request to EKS API server
6. EKS validates token with AWS STS
7. EKS looks up IAM principal in cluster access entries
8. EKS maps to associated access policy (`AmazonEKSClusterAdminPolicy`)
9. Request allowed or denied based on policy

Authentication uses IAM. Authorization uses EKS access entries and policies.

## Troubleshooting

### Error: You must be logged in to the server

Cause: IAM credentials not configured or AWS CLI cannot find credentials.

Solution: Configure AWS CLI with `aws configure` or set environment variables.

### Error: couldn't get current server API group list

Cause: IAM principal not in cluster access entries.

Solution: Add principal to `access_entries` in [terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/environments/dev/terraform.tfvars) and run `terraform apply`. See [Access Configuration](access-configuration.md).

### Error: error: You must be logged in to the server (Unauthorized)

Cause: Token expired or IAM credentials changed.

Solution: AWS CLI automatically refreshes tokens. If error persists, verify IAM credentials with `aws sts get-caller-identity`.

### Wrong cluster context

Cause: Multiple clusters configured and wrong context active.

Solution: Check `kubectl config get-contexts` and switch with `kubectl config use-context <context-name>`.
