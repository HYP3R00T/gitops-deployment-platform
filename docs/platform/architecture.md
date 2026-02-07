# System Architecture

The platform implements the following architectural patterns, designed to be swappable and portable. These patterns are the focus—not the specific tools.

## Architectural Patterns

| Category | Tools & Standards | Objective |
| -------- | ----------------- | --------- |
| **Cloud Platform** | AWS (EKS, VPC, IAM, CloudWatch) | Demonstrate enterprise-grade cloud resource management. |
| **Infrastructure** | Terraform, modular IaC patterns | Remove manual provisioning in favor of code-driven state. |
| **Automation** | GitHub Actions | Enable zero-touch deployment with automated reconciliation. |
| **Runtime** | Managed Kubernetes (EKS) | Leverage standard APIs for portability and stability. |
| **Artifacts** | Docker, Container Registry | Build immutable, versioned deployment units. |
| **Tooling** | `uv`, `mise`, Python 3.14+ | Ensure high-performance, modern toolchains for consistency. |
| **Governance** | Pre-commit, Commitizen, Dependabot | Shift-left quality checks and maintain supply chain security. |
| **Observability** | Health checks, semantic metadata | Allow the platform to validate its own deployment state. |

## Key Principle

The tools listed above are **implementation choices**, not the core design. The same architectural patterns could be implemented with different providers, orchestrators, or languages. The patterns themselves—not the tooling—are the reference implementation.
