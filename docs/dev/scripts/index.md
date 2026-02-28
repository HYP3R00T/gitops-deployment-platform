# Development Scripts

Utility scripts that automate common development tasks for environment setup, dependency management, and local service orchestration.

## Available Scripts

| Script | Purpose |
|--------|---------|
| [setup.sh](setup.md) | Initialize development environment with system dependencies and tools |
| [enter_project.sh](enter_project.md) | Install commit hooks and initialize project workflow tools |
| [apply-terraform-identity.sh](apply-terraform-identity.md) | Apply Terraform GitHub OIDC identity provider and IAM roles |
| [terraform-show-outputs.sh](terraform-show-outputs.md) | Show Terraform outputs for bootstrap, identity, dev, and prod |
| [docker-run-local.sh](docker-run-local.md) | Start local Docker containers for API and Web services |
| [docker-stop-local.sh](docker-stop-local.md) | Stop and clean up local Docker containers and networks |

## Quick Start

**First time in the project:**

```bash
./scripts/setup.sh
./scripts/enter_project.sh
```

**Run services locally:**

```bash
./scripts/docker-run-local.sh
```

Services available at:

- API: <http://localhost:8000>
- Web: <http://localhost:4321>

**Stop services:**

```bash
./scripts/docker-stop-local.sh
```

## See Also

- [Developer Setup](../developer-setup.md) - Complete development environment guide
- [Environment Variables](../environment-variables/index.md) - Configuration reference
