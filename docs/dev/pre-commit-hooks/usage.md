# Pre-commit Hooks Usage

This guide covers how to run, bypass, update, and troubleshoot pre-commit hooks.

## Running Hooks Manually

### Run All Hooks on All Files

```bash
pre-commit run --all-files
```

Use this when:

- First setting up pre-commit
- After updating hook versions
- To check the entire codebase

### Run All Hooks on Staged Files

```bash
pre-commit run
```

This is what runs automatically on commit, but you can run it manually to check before committing.

### Run a Specific Hook

```bash
pre-commit run <hook-id>
```

Examples:

```bash
pre-commit run ruff-check
pre-commit run commitizen
pre-commit run trailing-whitespace
pre-commit run terraform_fmt
```

### Run Hooks on Specific Files

```bash
pre-commit run --files path/to/file.py
pre-commit run --files infra/bootstrap/*.tf
```

## Bypassing Hooks (Not Recommended)

In rare cases where you need to commit without running hooks:

```bash
git commit --no-verify -m "your message"
```

**⚠️ Warning**: Only use this for:

- Emergency hotfixes
- Work-in-progress commits on feature branches
- When hooks are genuinely broken

Never bypass hooks on commits to `main` or release branches.

## Updating Hooks

Hook versions are pinned in `.pre-commit-config.yaml`. To update to the latest versions:

```bash
pre-commit autoupdate
```

This updates the `rev` field for each hook to the latest available version. Review the changes before committing.

## Troubleshooting

### Hook fails with "command not found"

The tool might not be installed. Pre-commit manages its own environments, but some hooks require system tools:

```bash
# Reinstall all hook environments
pre-commit clean
pre-commit install --install-hooks
```

### Hooks are not running

Verify hooks are installed:

```bash
pre-commit install
```

Check hook status:

```bash
pre-commit run --all-files
```

### Commits are being rejected

Read the error message carefully. Common issues:

- **Commitizen**: Commit message doesn't follow conventional format
- **Ruff**: Python code has linting errors that can't be auto-fixed
- **UV**: Lockfile is out of sync with `pyproject.toml`
- **Terraform**: Configuration has validation errors or formatting issues

Fix the issues and try committing again. Most formatting issues are fixed automatically.

### Performance is slow

Pre-commit runs in parallel when possible, but large changesets can be slow. To skip hooks temporarily during development:

```bash
git commit --no-verify
```

Run hooks manually before pushing:

```bash
pre-commit run --all-files
```

## CI/CD Integration

Pre-commit hooks also run in CI/CD pipelines to ensure code quality even if developers bypass local hooks. The CI configuration uses the same `.pre-commit-config.yaml` file, ensuring consistency between local and CI environments.

## Best Practices

1. **Run hooks early**: Don't wait until commit time. Run `pre-commit run` frequently during development
2. **Keep hooks updated**: Run `pre-commit autoupdate` monthly to get bug fixes and improvements
3. **Fix issues immediately**: Don't accumulate linting errors. Address them as they appear
4. **Understand what hooks do**: Read hook documentation when errors occur
5. **Don't bypass hooks habitually**: The `--no-verify` flag is for exceptions, not the rule
6. **Test after updates**: After running `autoupdate`, test all hooks on the full codebase

## Related Documentation

- [Pre-commit Hooks Overview](index.md) - Main documentation
- [Developer Setup](../developer-setup.md) - Initial environment configuration
- [Standard File Checks](standard-checks.md) - File validation hooks
- [Commit Message Formatting](commit-messages.md) - Commitizen hook
- [Python Hooks](python-hooks.md) - UV and Ruff hooks
- [Terraform Hooks](terraform-hooks.md) - Infrastructure code hooks
