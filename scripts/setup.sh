#!/bin/bash

# Trust mise configuration and install project dependencies
echo "Installing development tools..."
/usr/local/bin/mise trust /workspaces/gitops-deployment-platform/mise.toml && /usr/local/bin/mise install

# Update system package index and install system dependencies
sudo apt update && sudo apt install -y python3 tmux
echo "Setup complete!"
