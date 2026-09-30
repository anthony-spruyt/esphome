# ESPHome

My personal ESPHome configs for ESP32 devices around the house, all hooked into Home Assistant. Not meant for general use.

## Devices

| Config                                                                 | What it does                                                                | Board                |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------- | -------------------- |
| [aquarium-sensorbox](config/aquarium-sensorbox.yaml)                   | Air temp, humidity and pressure (AHT20 + BMP280), DS18B20 water temp probes | ESP32 dev            |
| [bambu-poop-conveyor](config/bambu-poop-conveyor.yaml)                 | Runs the X1C purge-waste conveyor (L298N motor), triggered by printer stage | ESP32 dev            |
| [garage-luminance-and-temp](config/garage-luminance-and-temp.yaml)     | Light level (BH1750), temp, humidity and pressure, BT proxy                 | ESP32 dev            |
| [kitchen-cyd](config/kitchen-cyd.yaml)                                 | LVGL power dashboard: solar generation, export, import, consumption         | Cheap Yellow Display |
| [powerpal-gateway](config/powerpal-gateway.yaml)                       | Reads the Powerpal energy meter over BLE                                    | M5Stack Atom Lite    |
| [x1c-bentobox](config/x1c-bentobox.yaml)                               | PWM fan control for the X1C bento box filter                                | ESP32-C3 Super Mini  |
| [x1c-chamber-vent-controller](config/x1c-chamber-vent-controller.yaml) | Opens/closes the X1C chamber riser vents with two linear actuators          | ESP32 dev            |

## Layout

Top-level files in `config/` are thin. They pick a WiFi package and a device template, and pass in vars.

```text
config/
├── <device>.yaml      # one per physical device
├── secrets.yaml       # not in git
└── packages/
    ├── boards/        # board definitions
    ├── common/        # base, WiFi, captive portal, BT, one-wire
    ├── components/    # reusable sensors (I2C, BH1750, AHT20/BMP280, DS18B20)
    ├── debug/         # extra logging and diagnostic sensors
    └── devices/       # full device templates
```

## Dashboard

Runs in Docker on the Windows/WSL host so compiles don't happen on the Raspberry Pi. Open <http://localhost:6052>.

```bash
docker compose up -d --build   # start
./start.sh                     # restart
docker compose down            # stop
```

## CLI

The dev container has the `esphome` CLI.

```bash
esphome config config/<device>.yaml
esphome run config/<device>.yaml    # compile + upload
esphome logs config/<device>.yaml
```

## Linting

```bash
pre-commit run --all-files
./lint.sh       # MegaLinter, with fixes
```
