# System Architecture

This page documents architecture that exists in this repository.

## Implemented Components

- Terraform backend bootstrap: [infra/bootstrap/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/bootstrap)
- GitHub OIDC identity setup: [infra/identity/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/identity)
- Local Kubernetes config: [local/kubernetes/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/local/kubernetes)
- API service: [services/api/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services/api)
- Web service: [services/web/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services/web)

## Terraform State

Remote state is backed by S3 from the bootstrap module.

- [Terraform Backend Bootstrap](terraform/backend-bootstrap/index.md)
- [S3 Native Locking](../thinking/s3-native-locking.md)

## GitHub Authentication to AWS

GitHub Actions authentication to AWS is configured with OIDC.

- [GitHub OIDC Identity](terraform/github-oidc-identity/index.md)
- [OIDC test workflow](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/oidc-test.yml)

## Related

- [CI/CD](ci-cd/index.md)
- [Local Kubernetes](local-kubernetes.md)
- [Docker Compose](docker-compose.md)
