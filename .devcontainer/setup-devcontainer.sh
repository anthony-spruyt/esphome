#!/bin/bash
set -euo pipefail

# Implement custom devcontainer setup here. This is run after the devcontainer has been created.

# Remove Yarn repo with expired GPG key (pre-installed in base image)
sudo rm -f /etc/apt/sources.list.d/yarn.list
