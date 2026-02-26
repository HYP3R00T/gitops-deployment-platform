# Tasks and Environment

This guide covers task execution failures and environment variable issues.

## Task Not Found

```bash
mise tasks
grep -A 2 "tasks.your-task-name" mise.toml
```

## Task Fails to Execute

```bash
mise run your-task-name -v
ls -la ./scripts/your-script.sh
chmod +x ./scripts/your-script.sh
```

## Variables Not Loaded from .env

```bash
ls -la .env
grep -A 2 "\[env\]" mise.toml
set -a; source .env; set +a
```

## Variable Conflicts

```bash
mise env
env | grep -i mise
env | grep -i aws
```
