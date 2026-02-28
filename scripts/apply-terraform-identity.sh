#!/bin/bash
set -e

echo "Applying Terraform Identity configuration (GitHub OIDC)..."

# Path to identity directory
IDENTITY_DIR="./infra/identity"

# Check if identity directory exists
if [ ! -d "$IDENTITY_DIR" ]; then
  echo "Error: Identity directory not found at $IDENTITY_DIR"
  exit 1
fi

# Check Terraform CLI
if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: Terraform CLI not found. Please install Terraform."
  exit 1
fi

# Check AWS CLI
if ! command -v aws >/dev/null 2>&1; then
  echo "Error: AWS CLI not found. Please install AWS CLI."
  exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "Error: Unable to authenticate with AWS. Check your credentials."
  exit 1
fi

# Check if state already exists
if [ -f "$IDENTITY_DIR/terraform.tfstate" ]; then
  echo "⚠  State file already exists. Resources may have already been created."
fi

# Run Terraform workflow
echo
echo "Initializing Terraform..."
terraform -chdir="$IDENTITY_DIR" init -upgrade

echo "Validating configuration..."
terraform -chdir="$IDENTITY_DIR" validate

echo "Planning changes..."
terraform -chdir="$IDENTITY_DIR" plan

echo
echo "Review the plan above."
echo "This will create AWS resources:"
echo "  - GitHub OIDC Identity Provider"
echo "  - IAM Roles for GitHub Actions (dev & prod)"
echo
read -p "Do you want to apply these changes? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Apply cancelled."
  exit 0
fi

echo "Applying changes..."
terraform -chdir="$IDENTITY_DIR" apply

echo
echo "✓ Identity configuration applied successfully!"
echo
echo "Key outputs:"
terraform -chdir="$IDENTITY_DIR" output -json | jq '{
  oidc_provider_arn,
  oidc_provider_url,
  dev_role_arn,
  prod_role_arn
}' 2>/dev/null || echo "Run: terraform -chdir=infra/identity output"
