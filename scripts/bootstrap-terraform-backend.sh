#!/bin/bash
set -e

echo "Bootstrapping Terraform backend (S3 + DynamoDB)..."

# Path to bootstrap directory
BOOTSTRAP_DIR="./infra/bootstrap"

# Check if bootstrap directory exists
if [ ! -d "$BOOTSTRAP_DIR" ]; then
  echo "Error: Bootstrap directory not found at $BOOTSTRAP_DIR"
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

# Check if resources already exist
if [ -f "$BOOTSTRAP_DIR/terraform.tfstate" ]; then
  echo "Warning: State file already exists. Resources may have already been created."
  echo ""
fi

# Run Terraform workflow
echo "Initializing Terraform..."
terraform -chdir="$BOOTSTRAP_DIR" init -upgrade

echo ""
echo "Validating configuration..."
terraform -chdir="$BOOTSTRAP_DIR" validate

echo ""
echo "Planning changes..."
terraform -chdir="$BOOTSTRAP_DIR" plan

echo ""
echo "Review the plan above."
echo "This will create AWS resources in ap-south-1:"
echo "  - S3 bucket (gitops-tfstate-<random>)"
echo "  - DynamoDB table (terraform-state-lock)"
echo ""
read -p "Do you want to apply these changes? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Apply cancelled."
  exit 0
fi

echo ""
echo "Applying changes..."
terraform -chdir="$BOOTSTRAP_DIR" apply

echo ""
echo "Bootstrap complete!"
echo "To view outputs: terraform -chdir=infra/bootstrap output"
