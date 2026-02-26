# System Architecture

The platform is being built around architectural patterns designed to be swappable and portable. These patterns are the focus-not the specific tools.

???+ note "Pattern-first mindset"
	Treat the listed tools as simple examples. The real value is the pattern (declarative infrastructure, automation, observability) that could move to other clouds or orchestration engines if needed.

## Target Architectural Patterns

| Category           | Tools & Standards                  | Objective                                                     | Status                  |
| ------------------ | ---------------------------------- | ------------------------------------------------------------- | ----------------------- |
| **Cloud Platform** | AWS (EKS, VPC, IAM, CloudWatch)    | Demonstrate enterprise-grade cloud resource management.       | Planned                |
| **Infrastructure** | Terraform, modular IaC patterns    | Remove manual provisioning in favor of code-driven state.     | Bootstrap complete     |
| **Automation**     | GitHub Actions                     | Enable zero-touch deployment with automated reconciliation.   | [Workflows documented](ci-cd/index.md) |
| **Runtime**        | Managed Kubernetes (EKS)           | Leverage standard APIs for portability and stability.         | Local (kind)           |
| **Artifacts**      | Docker, Container Registry         | Build immutable, versioned deployment units.                  | In progress            |
| **Tooling**        | `uv`, `mise`, Python 3.14+         | Ensure high-performance, modern toolchains for consistency.   | Complete               |
| **Governance**     | Pre-commit, Commitizen, Dependabot | Shift-left quality checks and maintain supply chain security. | Complete               |
| **Observability**  | Health checks, semantic metadata   | Allow the platform to validate its own deployment state.      | Basic implementation   |

## Key Principle

The tools listed above are **implementation choices**, not the core design. The same architectural patterns could be implemented with different providers, orchestrators, or languages. The patterns themselves-not the tooling-are the reference implementation.

## Current Implementation

### Completed Components

- **Local Development**: Devcontainer with mise-managed toolchain
- **Infrastructure Bootstrap**: S3 backend with native locking for Terraform state (`infra/bootstrap/`)
- **Code Quality**: Pre-commit hooks with validation for Python, Terraform, and file formats
- **Services**: Basic API (`services/api/`) and web frontend (`services/web/`)
- **Local Kubernetes**: kind cluster for development (`local/kubernetes/`)
- **Health Checks**: API service with health endpoint (`services/api/src/api/routes.py`)

### In Development

- **Cloud Infrastructure**: EKS, VPC, and IAM modules (directories exist at `infra/modules/` but not yet populated)
- **GitOps Controllers**: Flux or ArgoCD for reconciliation
- **Environment Configurations**: Dev and prod infrastructure (`infra/environments/`)

## Infrastructure State Management

Terraform state is managed centrally using an S3 backend with native state locking, provisioned via a bootstrap module. This ensures:

- **Consistency**: All infrastructure changes are tracked in versioned state files
- **Collaboration**: State locking prevents concurrent modification conflicts (when `use_lockfile = true` is configured)
- **Durability**: S3 versioning enables state recovery from accidents or corruption

???+ note "S3 Native Locking"
    State locking is provided by S3's native capabilities. Modules must explicitly enable it by setting `use_lockfile = true` in their backend configuration.

See [Terraform Backend Bootstrap](terraform/backend-bootstrap/index.md) for implementation details.
