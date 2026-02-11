# Pre-commit Hooks

This project uses [pre-commit](https://pre-commit.com/) to automatically enforce code quality standards, formatting consistency, and commit message conventions before code is committed to version control.

## What is Pre-commit?

Pre-commit is a framework for managing and maintaining multi-language pre-commit hooks. These hooks run automatically when you attempt to create a commit, checking and fixing issues before they enter the codebase.

???+ tip "Commit hygiene"
	Run pre-commit manually (`pre-commit run --all-files`) after a dependency change or CI failure to catch and fix issues before pushing again.

## Installation and Setup

Pre-commit is installed automatically via mise (configured in `mise.toml`). After cloning the repository and opening it in the devcontainer, run:

```bash
pre-commit install
```

This installs the git hooks into your local `.git` directory. You only need to do this once per clone.

## Configured Hooks

The pre-commit configuration is defined in `.pre-commit-config.yaml` at the repository root. The hooks are organized by category:

- **[Standard File Checks](standard-checks.md)** - JSON, YAML, TOML validation and file formatting
- **[Commit Message Formatting](commit-messages.md)** - Conventional Commits enforcement via Commitizen
- **[Python Hooks](python-hooks.md)** - Dependency management (uv) and code quality (ruff)
- **[Terraform Hooks](terraform-hooks.md)** - Infrastructure code formatting, validation, and security scanning

## Usage

For information on running, bypassing, updating, and troubleshooting hooks, see the [Usage Guide](usage.md).

## Related Documentation

- [Developer Setup](../developer-setup.md) - Initial environment configuration
- [Environment Variables](../environment-variables.md) - Configuration options
- Commit Message Guidelines: `.github/instructions/commitMessageGeneration.instructions.md`
- Ruff Configuration: `ruff.toml`

## External Resources

- [Pre-commit Documentation](https://pre-commit.com/)
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
