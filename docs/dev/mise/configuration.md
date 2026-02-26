# Mise Configuration Structure

The `mise.toml` file at the repository root defines all tools, settings, and tasks for the project.

## Tools

The `[tools]` section defines all CLI tools and their versions:

```toml
[tools]
github-cli = "latest"
python = "3.14"
node = "22.22.0"
uv = "latest"
pnpm = "latest"
pre-commit = "latest"
git-cliff = "latest"
markdownlint-cli2 = "latest"
aws-cli = "latest"
kubectl = "latest"
terraform = "1.14.5"
terraform-docs = "latest"
tflint = "latest"
tfenv = "latest"
# checkov = "latest"
```

### Installed Tools

| Tool                  | Version | Purpose                                 |
| --------------------- | ------- | --------------------------------------- |
| **github-cli**        | latest  | GitHub command-line interface           |
| **python**            | 3.14    | Python runtime for API service          |
| **node**              | 22.22.0 | Node.js runtime for web service         |
| **uv**                | latest  | Fast Python package manager             |
| **pnpm**              | latest  | Efficient Node.js package manager       |
| **pre-commit**        | latest  | Automated code quality checks on commit |
| **git-cliff**         | latest  | Changelog generation from commit history |
| **markdownlint-cli2** | latest  | Markdown linting for documentation      |
| **aws-cli**           | latest  | AWS command-line interface              |
| **kubectl**           | latest  | Kubernetes command-line tool            |
| **terraform**         | 1.14.5  | Infrastructure as Code provisioning     |
| **terraform-docs**    | latest  | Generate Terraform module documentation |
| **tflint**            | latest  | Terraform linter                        |
| **tfenv**             | latest  | Terraform version manager               |

???+ note "Commented Tools"
    `checkov` is currently commented out in `mise.toml`. Uncomment the line if you want to re-enable the security scanning hook, but ensure all dependencies are satisfied before installing it.

### Version Strategies

- **Pinned versions** (e.g., `python = "3.14"`): Used for languages where compatibility matters
- **Latest** (e.g., `aws-cli = "latest"`): Used for CLI tools that are frequently updated

## Settings

```toml
[settings]
experimental = true
idiomatic_version_file_enable_tools = ["python"]
```

- **`experimental = true`**: Enables mise's experimental features
- **`idiomatic_version_file_enable_tools`**: Allows mise to read `.python-version` files

## Hooks

```toml
[hooks]
enter = "bash ./scripts/enter_project.sh"
```

The **enter hook** runs automatically when you `cd` into the project directory. It executes `scripts/enter_project.sh`, which can:

- Display welcome messages
- Check prerequisites
- Set up project-specific shell configurations
- Validate environment setup

## Environment Variables

```toml
[env]
_.file = '.env'       # for sensitive data
UV_LINK_MODE = "copy"
```

- **`_.file = '.env'`**: Loads environment variables from `.env` file (see [Environment Variables](../environment-variables/index.md))
- **`UV_LINK_MODE = "copy"`**: Configures uv package manager to copy files instead of symlinking

## Tasks

Tasks provide convenient commands for common operations.

### `mise run docs`

```bash
mise run docs
```

Starts the local documentation server using zensical.

**What it does:**

- Runs `uv run zensical serve`
- Serves documentation at `http://localhost:8000`
- Hot-reloads on file changes

### `mise run kind-up`

```bash
mise run kind-up
```

Creates and configures a local Kubernetes cluster using kind.

**What it does:**

- Executes `scripts/create-kind-cluster.sh`
- Creates cluster with configuration from `local/kubernetes/kind.yaml`
- Sets up networking and ingress
- See [Local Kubernetes](../../platform/local-kubernetes.md) for details

### `mise run kind-down`

```bash
mise run kind-down
```

Deletes the local kind Kubernetes cluster.

**What it does:**

- Executes `scripts/delete-kind-cluster.sh`
- Removes cluster and associated resources
- Cleans up Docker containers

### `mise run kind-full`

```bash
mise run kind-full
```

Complete kind workflow: create cluster, build images, load, and deploy.

**What it does:**

- Executes `scripts/kind-full-workflow.sh`
- Creates a fresh kind cluster
- Builds service images
- Loads images into the cluster
- Deploys services
- See [Local Kubernetes](../../platform/local-kubernetes.md) for details

### `mise run kind-rebuild-api`

```bash
mise run kind-rebuild-api
```

Rebuild and redeploy API service only.

**What it does:**

- Executes `scripts/kind-rebuild-service.sh -s api`
- Rebuilds the API service image
- Reloads image into kind cluster
- Redeploys API service without affecting web service

### `mise run kind-rebuild-web`

```bash
mise run kind-rebuild-web
```

Rebuild and redeploy Web service only.

**What it does:**

- Executes `scripts/kind-rebuild-service.sh -s web`
- Rebuilds the Web service image
- Reloads image into kind cluster
- Redeploys Web service without affecting API service

### `mise run bootstrap-aws-tf-backend`

```bash
mise run bootstrap-aws-tf-backend
```

Bootstraps Terraform backend infrastructure (S3 with native locking support).

**What it does:**

- Executes `scripts/bootstrap-terraform-backend.sh`
- Creates S3 bucket for Terraform state (versioning enabled for native locking support)
- Note: Modules using this backend must set `use_lockfile = true` to enable locking
- See [Terraform Backend Bootstrap](../../platform/terraform/backend-bootstrap/index.md) for details
