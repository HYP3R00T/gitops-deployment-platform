# Installation and Activation

This guide covers missing tools, version conflicts, and installation failures.

## Tools Not Found

If commands are missing after installation:

```bash
mise activate
mise install
```

### Verification

```bash
mise list
mise which python
mise which terraform
```

## Version Conflicts

If versions do not match expected output:

```bash
mise list
mise install --force
```

## Enter Hook Not Running

The enter hook requires mise shell integration. In the devcontainer, this is configured automatically. If it is not working:

```bash
echo $MISE_SHELL
bash ./scripts/enter_project.sh
```

### Shell Integration Issues

```bash
mise doctor
mise activate
```

## Installation Failures

### Permission denied errors

```bash
ls -la ~/.local/share/mise
chmod -R u+w ~/.local/share/mise
```

### Failed download errors

```bash
curl -I https://mise.jdx.dev
mise install -v
```

### Tool-specific installation failures

Some tools require extra system dependencies:

```bash
sudo apt-get install build-essential libssl-dev zlib1g-dev
sudo apt-get install g++ make
```
