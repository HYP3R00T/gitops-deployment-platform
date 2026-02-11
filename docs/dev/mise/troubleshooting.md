# Mise Troubleshooting

## Tools Not Found

If commands aren't available after installation:

```bash
# Ensure mise is activated
mise activate

# Reinstall tools
mise install
```

### Verification

```bash
# Check which tools are installed
mise list

# Check which version of a command is being used
mise which python
mise which terraform
```

## Version Conflicts

If you see version mismatches or "command not found" errors:

```bash
# Check current versions
mise list

# Force reinstall all tools
mise install --force
```

## Enter Hook Not Running

The enter hook requires mise shell integration. In the devcontainer, this is configured automatically. If it's not working:

```bash
# Check if mise is activated
echo $MISE_SHELL

# Manually run the hook
bash ./scripts/enter_project.sh
```

### Shell Integration Issues

If mise commands work but automatic activation doesn't:

```bash
# Check mise configuration
mise doctor

# Verify shell integration
mise activate
```

## Installation Failures

### "Permission denied" errors

```bash
# Check file permissions
ls -la ~/.local/share/mise

# Reset mise directory permissions
chmod -R u+w ~/.local/share/mise
```

### "Failed to download" errors

```bash
# Check internet connectivity
curl -I https://mise.jdx.dev

# Try with verbose output
mise install -v
```

### Tool-specific installation failures

Some tools require additional system dependencies:

```bash
# For Python build errors
sudo apt-get install build-essential libssl-dev zlib1g-dev

# For Node.js build errors
sudo apt-get install g++ make
```

## Task Execution Problems

### Task not found

```bash
# List all available tasks
mise tasks

# Verify task name in mise.toml
grep -A 2 "tasks.your-task-name" mise.toml
```

### Task fails to execute

```bash
# Run with verbose output
mise run your-task-name -v

# Check if the script exists and is executable
ls -la ./scripts/your-script.sh
chmod +x ./scripts/your-script.sh
```

## Performance Issues

### Slow activation

```bash
# Check which tools are causing delays
mise activate --verbose

# Disable automatic activation temporarily
unset MISE_SHELL
```

### Disk space issues

```bash
# Check mise disk usage
du -sh ~/.local/share/mise

# Remove old tool versions
mise prune

# Remove unused plugins
mise plugins uninstall <plugin-name>
```

## Environment Variable Issues

### Variables not loaded from .env

```bash
# Verify .env file exists
ls -la .env

# Check mise.toml env configuration
grep -A 2 "\\[env\\]" mise.toml

# Manually source .env
set -a; source .env; set +a
```

### Variable conflicts

If environment variables aren't being set correctly:

```bash
# Check current environment
mise env

# Check for conflicts
env | grep -i mise
env | grep -i aws
```

## Getting Help

### Check Configuration Health

```bash
# Run mise doctor
mise doctor
```

This checks:

- mise installation
- shell integration
- plugin health
- tool installations
- configuration validity

### Debug Mode

```bash
# Enable debug logging
export MISE_DEBUG=1
mise install

# Or run specific command with debug
MISE_DEBUG=1 mise run docs
```

### Common Issues Summary

| Issue                         | Solution                                  |
| ----------------------------- | ----------------------------------------- |
| Command not found             | Run `mise install` and `mise activate`    |
| Version mismatch              | Run `mise install --force`                |
| Task not executing            | Check script permissions with `chmod +x`  |
| Environment variables missing | Verify `.env` file exists and is readable |
| Slow performance              | Run `mise prune` to remove old versions   |

## Related Documentation

- [Mise Configuration](configuration.md) - Configuration reference
- [Mise Usage](usage.md) - Common commands and operations
- [Developer Setup](../developer-setup.md) - Initial environment setup
