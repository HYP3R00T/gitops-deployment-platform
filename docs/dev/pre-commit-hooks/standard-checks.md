# Standard File Checks

**Source**: `pre-commit/pre-commit-hooks` (v6.0.0)

These hooks perform basic file validation and cleanup. They ensure consistent file formatting and catch common syntax errors.

## check-json

- **Purpose**: Validates JSON file syntax
- **When it runs**: On commit
- **What it fixes**: N/A (validation only)
- **Why we use it**: Prevents broken JSON files from being committed

## check-toml

- **Purpose**: Validates TOML file syntax
- **When it runs**: On commit
- **What it fixes**: N/A (validation only)
- **Why we use it**: Ensures configuration files (`mise.toml`, `zensical.toml`, `pyproject.toml`) are valid

## check-yaml

- **Purpose**: Validates YAML file syntax
- **When it runs**: On commit
- **What it fixes**: N/A (validation only)
- **Why we use it**: Ensures CI/CD configurations and Kubernetes manifests are valid

## end-of-file-fixer

- **Purpose**: Ensures files end with a single newline
- **When it runs**: On commit
- **What it fixes**: Adds or removes newlines at end of files
- **Why we use it**: Maintains POSIX compliance and consistent diff output

## trailing-whitespace

- **Purpose**: Removes trailing whitespace from lines
- **When it runs**: On commit
- **What it fixes**: Automatically removes trailing whitespace
- **Why we use it**: Reduces noise in diffs and prevents unnecessary changes

## check-shebang-scripts-are-executable

- **Purpose**: Ensures scripts with shebangs (e.g., `#!/bin/bash`) are executable
- **When it runs**: On commit
- **What it fixes**: N/A (validation only, alerts you to fix permissions)
- **Why we use it**: Prevents scripts that should be executable from being committed without proper permissions
