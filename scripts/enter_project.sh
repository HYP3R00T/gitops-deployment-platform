#!/bin/bash

# Install commitizen for standardized commit messages
if ! command -v cz >/dev/null; then
  echo "Installing commitizen..."
  pip install --user pipx
  pipx install commitizen
  echo "✓ Commitizen installed"
fi

# Install pre-commit hooks for automated validation
if [ ! -f .git/hooks/pre-commit ]; then
  pre-commit install
  pre-commit install --hook-type commit-msg
  echo "✓ Pre-commit hooks installed"
fi

echo "Development environment ready!"
