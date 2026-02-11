# Python Hooks

## Dependency Management

**Source**: `astral-sh/uv-pre-commit` (0.10.2)

These hooks ensure Python dependencies are synchronized and up-to-date.

### uv-lock

- **Purpose**: Updates `uv.lock` when `pyproject.toml` dependencies change
- **When it runs**: On commit
- **What it fixes**: Automatically runs `uv lock` to update lockfile
- **Why we use it**:
    - Keeps lockfile synchronized with dependencies
    - Prevents CI failures due to outdated lockfile
    - Ensures reproducible builds

### uv-export

- **Purpose**: Exports dependencies to `requirements.txt` for compatibility
- **When it runs**: On commit
- **What it fixes**: Generates `requirements.txt` from `pyproject.toml`
- **Why we use it**:
    - Maintains compatibility with tools that require `requirements.txt`
    - Provides fallback for environments without uv
    - Documents exact dependencies in traditional format

## Code Quality

**Source**: `astral-sh/ruff-pre-commit` (v0.15.0)

Ruff is an extremely fast Python linter and formatter written in Rust. Configuration is in `ruff.toml` at the repository root.

### ruff-check

- **Purpose**: Lints Python code for errors and style violations
- **When it runs**: On commit
- **What it fixes**: Automatically fixes auto-fixable issues with `--fix` flag
- **What it checks**:
    - Code style (PEP 8 compliance)
    - Common errors and anti-patterns
    - Import sorting and organization
    - Unused imports and variables
    - Complexity and maintainability issues
- **Why we use it**:
    - Catches bugs before they reach CI
    - Enforces consistent code style
    - Replaces multiple tools (flake8, isort, pylint)
    - Extremely fast (100x faster than traditional tools)

### ruff-format

- **Purpose**: Formats Python code automatically
- **When it runs**: On commit
- **What it fixes**:
    - Indentation and whitespace
    - Line length
    - Quote style
    - Trailing commas
- **Why we use it**:
    - Eliminates formatting debates
    - Compatible with Black formatting
    - Ensures consistent code appearance
    - Zero-config formatter

## External Resources

- [UV Documentation](https://docs.astral.sh/uv/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- Ruff Configuration: `ruff.toml`
