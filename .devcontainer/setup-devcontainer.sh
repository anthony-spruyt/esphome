#!/bin/bash
set -euo pipefail

# Implement custom devcontainer setup here. This is run after the devcontainer has been created.

# Remove Yarn repo with expired GPG key (pre-installed in base image)
sudo rm -f /etc/apt/sources.list.d/yarn.list

# Install ESPHome CLI (required by ESPHome VS Code extension)
pip install esphome

# Fix ownership of ESPHome build cache (created by Docker container as root)
# so the VS Code ESPHome extension can read/write to it
if [ -d "/workspaces/esphome/config/.esphome" ]; then
  sudo chown -R vscode:vscode /workspaces/esphome/config/.esphome
fi
