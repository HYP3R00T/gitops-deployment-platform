# Performance and Debugging

This guide covers slow activation, disk usage, and debugging.

## Slow Activation

```bash
mise activate --verbose
unset MISE_SHELL
```

## Disk Space Issues

```bash
du -sh ~/.local/share/mise
mise prune
mise plugins uninstall <plugin-name>
```

## Debug Mode

```bash
export MISE_DEBUG=1
mise install
MISE_DEBUG=1 mise run docs
```

## Common Issues Summary

| Issue | Solution |
| --- | --- |
| Command not found | Run `mise install` and `mise activate` |
| Version mismatch | Run `mise install --force` |
| Task not executing | Check script permissions with `chmod +x` |
| Environment variables missing | Verify `.env` exists and is readable |
| Slow performance | Run `mise prune` to remove old versions |

## Get Help

Run `mise doctor` to check installation, shell integration, plugins, and configuration.
