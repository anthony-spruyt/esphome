# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains ESPHome device configurations for ESP32-based IoT devices that integrate with Home Assistant. The `esphome` CLI is installed in the dev container; the dashboard runs in Docker on the host. Device configurations are organized using a package-based template system to maximize reusability.

## Development Commands

### Dashboard (run on the host)

`docker` inside the dev container is Podman, not the host's Docker, so run these on the host.

Start ESPHome dashboard (accessible at [http://localhost:6052](http://localhost:6052)):

```bash
docker compose up -d --build
```

Stop ESPHome:

```bash
docker compose down
```

Rebuild and restart:

```bash
./start.sh
```

### Linting and Validation

```bash
pre-commit run --all-files  # hooks from .pre-commit-config.yaml
./lint.sh                   # full MegaLinter suite, with fixes
./lint.sh --ci              # MegaLinter, no fixes
```

### ESPHome CLI

```bash
esphome config config/<device-name>.yaml
esphome compile config/<device-name>.yaml
esphome upload config/<device-name>.yaml
esphome logs config/<device-name>.yaml
```

## Repository Structure

### Configuration Architecture

Device configurations use a hierarchical package-based system with variable substitution:

```text
config/
├── <device-name>.yaml        # Top-level device configs
├── secrets.yaml               # Sensitive values (WiFi, API keys, etc.)
└── packages/
    ├── boards/                # Board-specific hardware definitions
    ├── common/                # Shared configurations (WiFi, base settings)
    ├── components/            # Reusable sensor/component configs
    ├── debug/                 # Debug utilities (logging, diagnostic sensors)
    └── devices/               # Complete device templates
```

### Package Pattern

Device configs reference packages using `!include` with variable substitution:

```yaml
packages:
  wifi: !include packages/common/.wifi-iot.yaml
  captive_portal:
    !include {
      file: packages/common/.captive-portal.yaml,
      vars: { device_name: my-device },
    }
  device:
    !include {
      file: packages/devices/.luminance.yaml,
      vars:
        {
          device_name: my-device,
          device_friendly_name: My Device,
          i2c_sda: 21,
          i2c_scl: 22,
        },
    }
```

**Key points:**

- Package files use dot-prefix (e.g., `.wifi-iot.yaml`, `.base.yaml`) by convention
- The `vars` mechanism allows parameterizing packages
- Packages can include other packages, creating composition hierarchies
- `secrets.yaml` stores sensitive values accessed via `!secret key_name`

### Common Packages

- **boards/** - Hardware definitions (`.dev.yaml`, `.m5stack-atom-lite.yaml`, `.cyd.yaml`)
- **common/.base.yaml** - Core ESPHome configuration (device name, logger, restart button)
- **common/.wifi-\*.yaml** - WiFi network configurations for different SSIDs
- **common/.captive-portal.yaml** - Fallback AP for device setup
- **common/.bt.yaml** - Bluetooth configuration
- **devices/** - Complete device templates combining board + components + logic

### External Components

Some devices use external ESPHome components from GitHub:

```yaml
external_components:
  - source:
      type: git
      url: https://github.com/gurrier/esphome-powerpal_ble.git
    components: [powerpal_ble]
    refresh: 1d
```

## Development Workflow

### Creating a New Device

1. Create a new file in `config/<device-name>.yaml`
2. Reference appropriate packages (wifi, board, device template)
3. Override or extend with device-specific configuration
4. Add secrets to `config/secrets.yaml` if needed
5. Validate with `esphome config`, then compile and upload

### Modifying Shared Configuration

When editing package files:

- Changes to files in `packages/` affect all devices that include them
- Test changes against multiple device configs before committing
- Consider backwards compatibility when modifying variable interfaces

### Framework Selection

Devices use either Arduino or ESP-IDF framework:

- ESP-IDF: Preferred for BLE, newer ESP32 variants, advanced features
- Arduino: Simpler, broader component compatibility

Specified in device packages:

```yaml
esp32:
  framework:
    type: esp-idf # or arduino
```

## Pre-commit Hooks

Hooks are defined in `.pre-commit-config.yaml` (yamllint, gitleaks, shellcheck, markdownlint, whitespace and line-ending fixers); `./lint.sh` runs the wider MegaLinter suite.

Hooks run automatically on commit. Bypass only when absolutely necessary:

```bash
git commit --no-verify
```

## Important Files and Directories

- **config/.esphome/** - ESPHome build cache (ignored by git, excluded from search)
- **build/** - Compiled firmware binaries (ignored by git, excluded from search)
- **docker-compose.yml** - ESPHome container configuration
- **.devcontainer/** - VS Code dev container setup with pre-commit, safe-chain security

## ESPHome Dashboard

The dashboard provides a web UI for:

- Viewing device status
- Compiling firmware
- Uploading over-the-air (OTA)
- Viewing logs
- Editing configurations

Access at [http://localhost:6052](http://localhost:6052) when container is running.

## Notes

- Never read `config/secrets.yaml`. The `Read` deny rule doesn't cover shell commands, so keep `grep -r`, `rg -u` and globs off `config/`. Append new secrets with `>>` without printing them.
- Device configs are stored in `config/` and mounted to the container's `/config`
- Build artifacts go to `build/` (mounted as `/build` in container)
- VSCode extension "ESPHome.esphome-vscode" provides schema validation
- All `.yaml` files are associated with ESPHome language server
- The repository uses safe-chain for supply chain security in npm/pip
