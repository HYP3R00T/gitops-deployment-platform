# Mise Best Practices

## Tool Versions

- **Pin language versions** - Ensures consistency across environments
- **Use "latest" for CLI tools** - Get security updates and new features
- **Document breaking changes** - If pinning a specific version, note why

### When to Pin vs. Use Latest

**Pin when:**

- The tool is a language runtime (Python, Node.js)
- Breaking changes are common
- You need to ensure exact reproducibility
- The tool version affects output or behavior

**Use latest when:**

- The tool is a CLI utility (aws-cli, kubectl)
- You want automatic security updates
- The tool follows semantic versioning well
- Breaking changes are rare

## Tasks

- **Keep tasks simple** - Complex logic should go in scripts
- **Use descriptive names** - `kind-up` is better than `k-up`
- **Add descriptions** - Help others understand what tasks do
- **Prefer scripts over inline commands** - Easier to test and maintain

### Task Design Patterns

**Good:**

```toml
[tasks.bootstrap-aws-tf-backend]
run = "bash ./scripts/bootstrap-terraform-backend.sh"
description = "Bootstrap Terraform backend (S3 + DynamoDB) for state management"
```

**Avoid:**

```toml
[tasks.bootstrap]
run = "cd infra/bootstrap && terraform init && terraform validate && terraform plan && terraform apply"
description = "Bootstrap"
```

## Environment Variables

- **Never commit secrets** - Use `.env` file (which is gitignored)
- **Document required variables** - See [Environment Variables](../environment-variables.md)
- **Use sensible defaults** - Where possible, make variables optional

### Environment Variable Naming

Use clear, prefixed names:

- **`PUBLIC_*`** - Variables exposed to frontend
- **`MISE_*`** - Mise-specific configuration
- **`AWS_*`** - AWS credentials and configuration
- **Service-specific** - Use service name as prefix

## Configuration Organization

Keep `mise.toml` organized by:

1. **Grouping related tools together** - Languages first, then package managers, then infrastructure tools
2. **Using consistent ordering** - Makes the file predictable and easier to maintain
3. **Commenting sparingly** - Only add comments where needed (e.g., to explain why a tool is disabled)
4. **Separating concerns** - Tools, settings, hooks, env, tasks in distinct sections

**Current structure:**

- Runtimes (python, node)
- Package managers (uv, pnpm)
- Code quality (pre-commit, markdownlint-cli2)
- Infrastructure (aws-cli, kubectl, terraform ecosystem)

## Maintenance

### Regular Updates

```bash
# Check for outdated tools
mise outdated

# Update specific tool
mise install python@latest

# Verify everything works
mise doctor
```

### Cleaning Up

```bash
# Remove unused tool versions
mise prune

# Remove all mise data and reinstall
mise implode
mise install
```

### Testing Changes

Before committing changes to `mise.toml`:

1. Run `mise install` to verify syntax
2. Test affected tools
3. Run `mise doctor` to check for issues
4. Ensure all tasks still work
