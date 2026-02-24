# setup.sh

Initializes the development environment by installing system dependencies and development tools.

## Purpose

Performs the initial setup of the development container by installing required tools and system packages. This is typically run once when setting up a new development environment.

## What It Does

1. **Trusts mise configuration** - Makes `mise` tool available for managing dev dependencies
   - Installs all project dependencies specified in `mise.toml`
   - `mise` is a polyglot version manager that handles Python, Node.js, Terraform, and other tools

2. **Updates system packages** - Ensures apt package index is current

3. **Installs system tools**:
   - `python3` - Required for Python-based services and tooling
   - `tmux` - Terminal multiplexer for session management during development

## Usage

```bash
./scripts/setup.sh
```

This script requires `sudo` for system package installation. You may be prompted for your password.

## When to Run

- **Container setup** - Run once when initializing a new dev container
- **Dependency updates** - Safe to run multiple times if you need to update dependencies

## What Gets Installed

| Tool | Purpose |
|------|---------|
| `mise` | Version manager (auto-installs Python, Node.js, Terraform versions from `mise.toml`) |
| `python3` | Python runtime for API service and tools |
| `tmux` | Terminal multiplexer for managing multiple terminal sessions |

## Environment File

`mise.toml` in the project root defines exact versions of all managed tools. Users do not need to manually manage versions.

## Related Files

- `mise.toml` - Defines all managed tool versions and configurations
- `pyproject.toml` - Defines Python project dependencies
