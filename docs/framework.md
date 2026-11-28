# Framework laptop

[← README](../README.md)

Both Framework 13 boards use the config in `hosts/framework/`. The only difference is one small file per board.

| Host              | Board          | File        | What the file adds                                              |
| ----------------- | -------------- | ----------- | --------------------------------------------------------------- |
| `framework`       | Ryzen 7040     | `amd.nix`   | The nixos-hardware module for the AMD board, and `amdgpu_top`    |
| `framework-intel` | Intel 12th-gen | `intel.nix` | The nixos-hardware module for the Intel board, and `intel-gpu-tools` |

No machine runs `framework-intel` yet. It's there for when the old Intel board goes into its own case. Because it shares everything else with `framework`, it stays up to date without any extra work. After the first install, its hostname will still be `framework`, so switch once with `nh os switch -H framework-intel`.

Everything below applies to both boards.

## Presentation mode

When an external display is plugged in, `Mod+P` cycles through three modes: off, extend, and mirror, then back to off. If no external display is connected, the key does nothing. The code is in `hosts/framework/present.nix`.

| Mode   | External display                              | Laptop screen                                                   |
| ------ | --------------------------------------------- | --------------------------------------------------------------- |
| Off    | Works the way Umbriel normally handles it     | Normal                                                          |
| Extend | A separate screen with its own workspaces     | Normal, with a small live preview of the external display in the bottom-right corner |
| Mirror | Shows the laptop screen, fullscreen           | Normal                                                          |

A few things happen along the way:

- When you switch to extend or mirror, Noctalia's caffeine and Do Not Disturb turn on, so the screen won't lock and notifications won't pop up. They turn off again when you go back to off.
- If you unplug the display during extend or mirror, the laptop goes back to off by itself.
- If more than one external display is connected, it uses the first one by name, so `DP-1` comes before `DP-2`. It stays on that display until you go back to off.
- The laptop screen is 3:2, so mirroring to a 16:9 display leaves black bars on the left and right. Use extend if you want to fill the external screen.
- Apps that block screen capture, like Proton Pass, Vesktop, and Element, don't show up in the mirror or the preview. You see whatever is behind them instead.

You can also use the `present` command in a terminal:

```sh
present            # same as pressing Mod+P
present status     # prints off, extend, or mirror
present extend     # switch straight to a mode (extend, mirror, or off)
```

Behind the scenes, wl-mirror runs as a user service called `present-mirror`. A second service, `present-watch`, notices when the display is unplugged. It only runs while presenting, so presentation mode uses no battery when it's off. Two Umbriel quirks shaped how this works, and [troubleshooting](troubleshooting.md#wl-mirror-windows) explains them.

## Power, battery, and sleep

Closing the lid suspends the laptop, and Noctalia locks the screen first. If an external display is connected, closing the lid doesn't suspend. That's logind's default behaviour.

The power button locks the screen instead of shutting down.

When idle, Noctalia locks the screen after 5 minutes, turns it off after 10, and suspends after 15.

`low-battery-shutdown.nix` protects the battery during sleep. Before the laptop suspends, it sets an alarm to wake it every 30 minutes. If it wakes with the lid closed, on battery, and below 20%, it shuts down. Otherwise it goes back to sleep. Opening the lid wakes it up normally.

`powertop --auto-tune` runs at boot. You can change the power profile from Noctalia's control center.

## Bluetooth

Bluetooth remembers whether you left it on or off, no matter how you changed it. The state is saved at shutdown and restored at boot by `bluetooth-power.nix`. On the very first boot nothing is saved yet, so Bluetooth starts on.

## pCloud

pCloud only runs when the laptop is on Wi-Fi and plugged in. `pcloud.nix` checks every 2 minutes.

- It starts pCloud when the laptop is on Wi-Fi and AC power.
- It stops pCloud right away if you turn Wi-Fi off, or if the battery drops below 15% while unplugged.
- It waits a while before stopping pCloud in other cases. It waits 5 minutes after losing the Wi-Fi connection and 10 minutes after you unplug.
- pCloud also stops before the laptop sleeps. If pCloud gets killed, its drive is unmounted cleanly.

## Fingerprint reader

The fingerprint reader is enabled, and its service restarts a couple of seconds after every resume. Fingerprints are turned off for console login, the login screen, and `sudo`, so those always ask for your password.

## SSH

The laptop only accepts SSH over Tailscale. Port 22 is closed on every other network. Only key login is allowed, and root can't log in.

## Display

The built-in screen (`eDP-1`) runs at 2256×1504 and 60 Hz with no scaling. It has workspaces 1 to 9 plus `stuff`. Fonts are set larger on this host: GTK uses 21, foot uses 17, and Zed uses 20 for the interface and 21 for code.

## kanata

The built-in keyboard uses the Graphite layout through kanata. The [keybinds page](keybinds.md#kanata-framework-built-in-keyboard) describes the layers.
