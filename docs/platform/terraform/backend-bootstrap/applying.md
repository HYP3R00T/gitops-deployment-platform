# Applying the Bootstrap

This guide covers how to create the Terraform backend infrastructure.

## Automated Method (Recommended)

Use the provided script via mise task:

```bash
mise run bootstrap-aws-tf-backend
```

The script `scripts/bootstrap-terraform-backend.sh` performs these steps:

1. **Verify Prerequisites**: Check for Terraform CLI, AWS CLI, and AWS credentials
2. **Initialize**: Download required Terraform providers
3. **Validate**: Ensure configuration syntax is correct
4. **Plan**: Display resources to be created
5. **Confirm**: Wait for your approval before applying changes
6. **Apply**: Create the AWS infrastructure

The script includes safety checks and warns if resources already exist.

???+ warning "Idempotency warning"
  The bootstrap assumes no pre-existing S3 bucket/DynamoDB table with the same prefix. If you already ran it, double-check the AWS resources before reapplying to avoid accidental collisions.

## Manual Method

Alternatively, run Terraform commands directly from the workspace root:

```bash
terraform -chdir=infra/bootstrap init
terraform -chdir=infra/bootstrap validate
terraform -chdir=infra/bootstrap plan
terraform -chdir=infra/bootstrap apply
```

## After Bootstrap

After successful application, capture the outputs:

```bash
terraform -chdir=infra/bootstrap output
```

The `backend_config` output provides the exact configuration snippet for other modules.

## AWS Credentials

The development container includes AWS CLI with credentials mounted from the host system (see `.devcontainer/devcontainer.json`):

```json
"mounts": [
  "source=${localEnv:HOME}/.aws,target=/home/vscode/.aws,type=bind"
]
```

### Option 1: Host Machine Credentials (Recommended)

Ensure your `~/.aws/credentials` are configured before running the bootstrap:

```bash
aws configure
```

### Option 2: Environment Variables

If AWS CLI is not configured on your host machine, provide credentials via the `.env` file in the project root:

```bash
# Copy the example file
cp .env.example .env

# Edit .env and uncomment AWS credentials section
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_DEFAULT_REGION=ap-south-1
```

The `.env` file is loaded by mise and makes credentials available to all AWS CLI and Terraform commands.

See [Environment Variables](../../../dev/environment-variables.md) for more details.

## Tooling

### Terraform and AWS CLI

Terraform and AWS CLI versions are managed in `mise.toml`:

```toml
terraform = "latest"
aws-cli = "latest"
```

### Mise Task

The bootstrap process is available as a mise task:

```toml
[tasks.bootstrap-aws-tf-backend]
run = "bash ./scripts/bootstrap-terraform-backend.sh"
description = "Bootstrap Terraform backend (S3 + DynamoDB) for state management"
```

Run with: `mise run bootstrap-aws-tf-backend`
