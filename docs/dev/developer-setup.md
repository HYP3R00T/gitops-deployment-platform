# Developer Setup

This repository uses devcontainer technology ([why?](../thinking/devcontainer.md)) to provide a consistent development environment across all contributors. This document explains the rationale behind using devcontainers, how to get started with them, and the prerequisites for using them effectively.

The goal is not convenience alone, but **environmental consistency**.

???+ info "Consistency First"
    The devcontainer defines the canonical workspace. If it builds and the automated checks pass, the environment is healthy.

## Pre-requsites for using the devcontainer

- [Docker](https://docs.docker.com/)
- [Visual Studio Code](https://code.visualstudio.com/) - [Remote Development Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
- [Git](https://git-scm.com/)
- **AWS CLI Configuration** (for infrastructure provisioning)
    - Local `~/.aws` directory with valid credentials
    - This is mounted into the devcontainer automatically (see `.devcontainer/devcontainer.json`)
    - Only required if working with Terraform infrastructure modules

???+ warning "Credential scope"
    Enable AWS credentials only when you need Terraform or AWS tooling. Keeping the rest of your workflow credential-free reduces the risk of accidental cloud changes.

## Getting Started with the DevContainer

- Create a `fork` of this repository in GitHub.
- Clone your fork locally.
- Open the cloned repository in Visual Studio Code.
- When prompted, choose to "Reopen in Container".
- The devcontainer will build and set up the environment. This may take a few minutes on the first run.
- Once the devcontainer is running, you can work on the project as you normally would.

## Environment Configuration

The project uses environment variables for configuration, managed through a `.env` file. After setting up the devcontainer:

1. Copy the environment template:

    ```bash
    cp .env.example .env
    ```

2. Edit `.env` with your credentials and configuration

???+ danger "Protect `.env`"
    `.env` contains all of your secrets, so keep it gitignored and never paste it into shared contexts. Rotate values immediately if you suspect exposure.

See [Environment Variables](environment-variables.md) for detailed documentation on:

- GitHub token configuration and permissions
- AWS credentials setup
- Service configuration options
- Security best practices

## Pre-commit Hooks

The project uses pre-commit hooks to enforce code quality and consistency. After setting up the devcontainer, install the hooks:

```bash
pre-commit install
```

This enables automatic checks before each commit for:

- File format validation (JSON, YAML, TOML)
- Code formatting and linting (Python with Ruff)
- Commit message format (Conventional Commits)
- Dependency synchronization (UV lockfiles)

???+ tip "Warm up hooks"
    Run `pre-commit run --all-files` immediately after installing the hooks. That preloads each environment and prevents surprises during your next commit.

See [Pre-commit Hooks](pre-commit-hooks/index.md) for comprehensive documentation on all configured hooks.

## Tool Management with Mise

The project uses [mise](https://mise.jdx.dev/) to manage development tools and automation tasks. Mise is already installed and configured in the devcontainer.

When you enter the project directory, mise automatically:

- Installs required tools (Python, Node.js, Terraform, kubectl, etc.)
- Activates correct versions for consistency
- Sets up project-specific environment variables

**Common tasks available:**

```bash
# Serve documentation locally
mise run docs

# Create local Kubernetes cluster
mise run kind-up

# Delete local Kubernetes cluster
mise run kind-down

# Bootstrap Terraform backend
mise run bootstrap-aws-tf-backend
```

See [Mise Configuration](mise/index.md) for comprehensive documentation on:

- All available tools and their versions
- Task definitions and usage
- Adding new tools or tasks
- Troubleshooting mise issues

## Getting Started with local setup

While using the devcontainer is recommended, you can also set up your local environment manually. However, you must ensure that your local setup matches the configurations defined in the repository (e.g., Node.js version, package versions).
Refer to the `devcontainer.json` and any related configuration files for the specific versions and tools required.
