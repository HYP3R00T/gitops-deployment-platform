# enter_project.sh

Initializes the development environment by installing commit message linting and pre-commit hooks.

## Purpose

Ensures developers follow consistent commit message standards and run automated checks before committing code. Installs and configures tools that are essential for maintaining code quality.

## Tools Installed

1. **Commitizen** - Enforces standardized commit messages (via `commitizen` CLI)
   - Guides developers through interactive commit message creation
   - Ensures messages follow conventional commit format
   - Installed via `pipx` for isolated Python environment

2. **Pre-commit** - Automatically runs checks before commits
   - Git hooks configured for automated validation
   - Prevents committing code that fails linting, formatting, or tests
   - Hooks configured:
     - `pre-commit` - Runs before commit creation
     - `commit-msg` - Validates commit message format

## Usage

```bash
./scripts/enter_project.sh
```

This script idempotently checks if tools are installed and only installs if needed:

- If `commitizen` (`cz`) is missing, it installs `pipx` and then `commitizen`
- If pre-commit Git hooks are missing, it runs `pre-commit install`

## When to Run

- **First time** in the project - Run this to set up the development environment
- **Safe to run** multiple times - Script checks if tools exist before installing

## What Gets Modified

- `~/.local/bin/` - Adds `commitizen` command (via pipx)
- `.git/hooks/pre-commit` - Installs pre-commit hook
- `.git/hooks/commit-msg` - Installs commit message validation hook

## Related Documentation

See `.github/instructions/commitMessageGeneration.instructions.md` for commit message standards.
