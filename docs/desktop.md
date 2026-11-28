# Desktop

[← README](../README.md)

The desktop's config is in `hosts/desktop/`.

## Monitors and bars

`monitors.nix` gives the two monitors names so the rest of the config can refer to them.

| Name     | Output | Bar                                                                          |
| -------- | ------ | ---------------------------------------------------------------------------- |
| `middle` | `DP-1` | A horizontal bar with the launcher, workspaces, volume, RAM, CPU, network, clock, and notifications |
| `left`   | `DP-2` | A vertical bar, since this monitor is portrait. It shows workspaces, media, the tray, caffeine, Bluetooth, and the clock. |

Each monitor has a login box on the lock screen. `DP-1` also shows the time and date, and `DP-2` shows an audio visualizer.

## Idle

Noctalia handles idle in four steps.

| After      | What happens                                         |
| ---------- | ---------------------------------------------------- |
| 10 minutes | The screen locks                                     |
| 15 minutes | The screen turns off                                 |
| 30 minutes | The PC suspends, unless media is playing             |
| 2 hours    | The PC suspends even if media is playing             |

## GPU and Ollama

The AMD GPU is set up for ROCm, so compute apps can use it. `lact` is installed to manage the GPU, and `amdgpu_top` shows what it's doing.

Ollama is installed with ROCm support, but it doesn't start at boot. Start it with `sudo systemctl start ollama`. It listens on port 11434, and the firewall only lets one machine on the local network reach it, `192.168.88.2`. Models stay loaded for 30 minutes after their last use. The context is capped at 16k tokens to leave some free video memory.

## Gaming

The desktop turns on `custom.games`. That installs Steam with Proton GE, Remote Play, and local network game transfers, along with r2modman and Prism Launcher. Xbox controllers work through the `xone` driver.

## Waking up

You can wake the desktop over the network with wake-on-LAN on `enp2s0`. From another machine, run `wakeonlan <MAC>`.

Waking from USB is set per device in `udev.extraRules`. Two devices are allowed to wake the PC and one isn't. Waking from Bluetooth stopped working, so it isn't used.

## Differences from the laptop

- SSH also works from the local network, not just over Tailscale.
- Bluetooth turns on at boot, with experimental features and fast connect enabled.
- The ZFS pool isn't encrypted.
- EasyEffects runs for audio processing.
- UDP port 5678 is open. MikroTik's Winbox uses it to find routers on the network.
