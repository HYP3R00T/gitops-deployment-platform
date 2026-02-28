# Content Mapping Registry

Map code locations to documentation locations.

## Code to Documentation

| Code Location | Documentation | Coupling | Notes |
|---|---|---|---|
| [scripts/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/scripts) | [dev/scripts/](../dev/scripts/index.md) | Strong | Script behavior and usage |
| [services/api/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services/api) | [services/api.md](../services/api.md) | Strong | API behavior and setup |
| [services/web/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services/web) | [services/web.md](../services/web.md) | Strong | Web behavior and setup |
| [infra/bootstrap/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/bootstrap) | [platform/terraform/backend-bootstrap/](../platform/terraform/backend-bootstrap/index.md) | Strong | Backend and state setup |
| [infra/identity/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/identity) | [platform/terraform/github-oidc-identity/](../platform/terraform/github-oidc-identity/index.md) | Strong | OIDC provider and role |
| [infra/environments/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/environments) | [platform/terraform/eks-environments/](../platform/terraform/eks-environments/index.md) | Strong | EKS cluster and VPC config |
| [infra/modules/eks/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules/eks) | [platform/terraform/eks-environments/](../platform/terraform/eks-environments/index.md) | Strong | EKS wrapper module |
| [infra/modules/vpc/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules/vpc) | [platform/terraform/eks-environments/](../platform/terraform/eks-environments/index.md) | Strong | VPC wrapper module |
| [gitops/clusters/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/clusters) | [platform/gitops/](../platform/gitops/index.md) | Strong | FluxCD bootstrap manifests |
| [gitops/apps/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/apps) | [platform/gitops/app-manifests/](../platform/gitops/app-manifests/index.md) | Weak | Application manifests structure and customization |
| [.github/workflows/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/.github/workflows) | [platform/ci-cd/](../platform/ci-cd/index.md) | Strong | Pipeline behavior |
| [local/kubernetes/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/local/kubernetes) | [platform/local-kubernetes.md](../platform/local-kubernetes.md) | Weak | Local cluster overview |
| [gitops/apps/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/apps) | [platform/local-kubernetes.md](../platform/local-kubernetes.md) | Weak | GitOps manifests overview |
| [mise.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/mise.toml) | [dev/mise/](../dev/mise/index.md) | Strong | Tool and task config |
| [.pre-commit-config.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.pre-commit-config.yaml) | [dev/pre-commit-hooks/](../dev/pre-commit-hooks/index.md) | Strong | Hook behavior |
| [docker-compose.yml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/docker-compose.yml) | [platform/docker-compose.md](../platform/docker-compose.md) | Weak | Local orchestration |
| [zensical.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/zensical.toml) | [dev/authoring-documentation.md](../dev/authoring-documentation.md) | Weak | Docs tooling config |

## Documentation to Code

| Documentation | Code to Review |
|---|---|
| [dev/scripts/](../dev/scripts/index.md) | [scripts/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/scripts) |
| [services/api.md](../services/api.md) | [services/api/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services/api) |
| [services/web.md](../services/web.md) | [services/web/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services/web) |
| [platform/terraform/backend-bootstrap/](../platform/terraform/backend-bootstrap/index.md) | [infra/bootstrap/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/bootstrap) |
| [platform/terraform/github-oidc-identity/](../platform/terraform/github-oidc-identity/index.md) | [infra/identity/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/identity) |
| [platform/terraform/eks-environments/](../platform/terraform/eks-environments/index.md) | [infra/environments/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/environments), [infra/modules/eks/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules/eks), [infra/modules/vpc/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules/vpc) |
| [platform/gitops/](../platform/gitops/index.md) | [gitops/clusters/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/clusters) |
| [platform/gitops/app-manifests/](../platform/gitops/app-manifests/index.md) | [gitops/apps/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/apps) |
| [platform/ci-cd/](../platform/ci-cd/index.md) | [.github/workflows/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/.github/workflows) |
| [platform/local-kubernetes.md](../platform/local-kubernetes.md) | [local/kubernetes/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/local/kubernetes), [gitops/apps/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/apps) |

## Coupling

- Strong: code changes require immediate doc updates.
- Weak: update docs when behavior changes materially.

## See Also

- [Documentation Principles](documentation-principles/index.md)
- [Authoring Documentation](../dev/authoring-documentation.md)
