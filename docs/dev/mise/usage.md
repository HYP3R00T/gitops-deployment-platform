# Mise Usage

## Installation (Inside Devcontainer)

Mise is already installed in the devcontainer. When you enter the project directory, mise automatically:

1. Installs any missing tools defined in `mise.toml`
2. Activates the correct versions
3. Runs the enter hook

## Manual Tool Installation

To manually install all tools:

```bash
mise install
```

## Checking Tool Versions

```bash
mise list
```

Shows all installed tools and their versions.

## Running Tasks

```bash
# List all available tasks
mise tasks

# Run a specific task
mise run <task-name>

# Example
mise run docs
```

See [Configuration](configuration.md#tasks) for details on all available tasks.

## Adding New Tools

To add a new tool:

1. Edit `mise.toml`:

    ```toml
    [tools]
    new-tool = "version"
    ```

2. Install it:

    ```bash
    mise install
    ```

## Adding New Tasks

To add a new task:

```toml
[tasks.my-task]
run = "command to execute"
description = "Description of what this task does"
```

Then run it with:

```bash
mise run my-task
```

## Common Commands

| Command                | Description                         |
| ---------------------- | ----------------------------------- |
| `mise install`         | Install all tools from mise.toml    |
| `mise list`            | Show installed tools and versions   |
| `mise tasks`           | List all available tasks            |
| `mise run <task-name>` | Execute a specific task             |
| `mise doctor`          | Check mise configuration and health |
| `mise upgrade`         | Upgrade mise itself                 |
| `mise prune`           | Remove unused tool versions         |
| `mise install --force` | Reinstall all tools                 |
| `mise which <command>` | Show which tool provides a command  |
| `mise current`         | Show currently active tool versions |
