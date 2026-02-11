# Terraform Infrastructure Hooks

**Source**: `antonbabenko/pre-commit-terraform` (v1.105.0)

Terraform-specific hooks ensure infrastructure code is properly formatted, validated, and secure before being committed.

## terraform_checkov

- **Purpose**: Static security analysis of Terraform templates
- **When it runs**: On commit
- **What it checks**:
    - Security misconfigurations
    - Compliance violations
    - Best practice deviations
    - Common infrastructure vulnerabilities
- **What it fixes**: N/A (reports issues only)
- **Why we use it**:
    - Catches security issues before deployment
    - Enforces cloud security standards
    - Prevents common misconfigurations
    - Provides detailed remediation guidance

**Note**: Currently commented out in `.pre-commit-config.yaml` but can be enabled when needed.

## terraform_fmt

- **Purpose**: Formats Terraform configuration files to canonical format
- **When it runs**: On commit
- **What it fixes**:
    - Indentation and alignment
    - Argument ordering
    - Whitespace normalization
- **Why we use it**:
    - Ensures consistent code style
    - Eliminates formatting debates
    - Makes code reviews focus on logic
    - Automatic formatting with zero configuration

## terraform_validate

- **Purpose**: Validates Terraform configuration files
- **When it runs**: On commit
- **What it checks**:
    - Syntax errors
    - Invalid resource references
    - Type mismatches
    - Missing required arguments
    - Provider configuration issues
- **What it fixes**: Automatically reinitializes `.terraform` directory if corrupted (with `--retry-once-with-cleanup` flag)
- **Why we use it**:
    - Catches errors before terraform apply
    - Validates module references
    - Ensures provider compatibility
- **Requires**: `jq` for cleanup feature

## terraform_docs

- **Purpose**: Auto-generates documentation for Terraform modules
- **When it runs**: On commit
- **What it creates**:
    - Input variables table with descriptions, types, and defaults
    - Output values documentation
    - Resource lists
    - Provider requirements
- **What it fixes**: Updates documentation between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers
- **Why we use it**:
    - Keeps documentation synchronized with code
    - Eliminates manual documentation updates
    - Improves module discoverability
- **Requires**: `terraform-docs` binary

**Configuration**: Currently configured to update `infra/bootstrap/README.md`.

## terraform_tflint

- **Purpose**: Linter for Terraform code to detect errors and enforce best practices
- **When it runs**: On commit
- **What it checks**:
    - Deprecated syntax
    - Unused declarations
    - Invalid module sources
    - AWS-specific errors (with plugins)
    - Best practice violations
- **What it fixes**: N/A (reports issues only)
- **Why we use it**:
    - Catches issues terraform validate misses
    - Enforces cloud provider best practices
    - Detects deprecated features
    - Provides actionable error messages
- **Requires**: `tflint` binary

**Configuration**: Uses `--call-module-type=all` to check all module types including external modules.

## External Resources

- [pre-commit-terraform Documentation](https://github.com/antonbabenko/pre-commit-terraform)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Checkov Documentation](https://www.checkov.io/)
- [terraform-docs Documentation](https://terraform-docs.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
