# appleboblin's NixOS Config

## Features

- Multiple NixOS hosts (desktop, Framework 13 with either the Ryzen 7040 or 12th-gen Intel mainboard) from one flake, with Home Manager as a NixOS module
- Both Framework boards share `hosts/framework/`; only `amd.nix` / `intel.nix` differ
- ZFS root with zram swap, installed by a guided script (disk selection, partitioning, encryption on the laptop)
- Umbriel with the Noctalia shell and greeter
- `umbriel-toggle-app`: one key to jump to an app (launching it if needed) and back
- Vesktop and Spotify start on the `stuff` workspace on every host
- Catppuccin Macchiato (Pink accent) across GTK, Qt/Kvantum, terminal, and editors
- CI: PRs build every host; pushes to `main` check formatting; `flake.lock` updates weekly and auto-merges when builds pass
- Binary caches for Noctalia and Umbriel, so they aren't compiled locally
- `nh` for rebuilds with package diffs, plus automatic store cleanup
- Dev shell templates (`init c|py|rs|js`) that load automatically through direnv
- Laptop extras: kanata (Graphite layout), fingerprint login, Bluetooth state remembered across reboots, Wi-Fi/power-aware pCloud sync
- Editors: Zed and Nixvim

## How to Install

> [!CAUTION]
> The script **erases the selected disk** and creates a ZFS pool on it.

Run the command below from a terminal on a NixOS live ISO, or from a TTY on the minimal ISO. The script creates the disk partitions, sets the necessary flags, and installs NixOS.

```sh
sh <(curl -L https://raw.githubusercontent.com/appleboblin/dotfiles-nixos/refs/heads/main/install.sh)
```

## Adding a New Host

1. Create a directory in `hosts/` named after the new hostname, following the same layout as the existing hosts
2. Register it in `flake.nix` under `nixosConfigurations`:

```nix
   NEW_HOSTNAME = mkHost { host = "NEW_HOSTNAME"; };
```

3. Add `NEW_HOSTNAME` to the `hosts=(...)` list in `install.sh` and to the `host:` matrix in `.github/workflows/check.yml`
4. Boot the new machine into the live ISO and run:

```sh
   nixos-generate-config --no-filesystems --show-hardware-config
```

5. Copy the output into `hosts/NEW_HOSTNAME/hardware.nix` (a pastebin or similar works for getting it off the machine)
6. Set `networking.hostId` in `hosts/NEW_HOSTNAME/configuration.nix` (ZFS requires it). `install.sh` prints one, or generate it with `head -c 8 /etc/machine-id`
7. Push the updated config, then follow [How to Install](#how-to-install) above

### Hosts that share a directory

A machine that differs from an existing host only in hardware can reuse that host's directory. `dir` picks the `hosts/` directory and `extraModules` adds the per-machine file, as the two Framework boards do:

```nix
   framework-intel = mkHost {
     host = "framework-intel";
     dir = "framework";
     extraModules = [ ./hosts/framework/intel.nix ];
   };
```

## Usage

| Command           | Does                                                                                          |
| ----------------- | --------------------------------------------------------------------------------------------- |
| `rebuild`         | Formats the repo, stages changes, and switches with `nh` (shows a diff, asks before applying) |
| `update`          | Pulls the latest `main` (including the tested `flake.lock`) and rebuilds                      |
| `garbage`         | Removes generations older than 14 days, keeping at least 5                                    |
| `delete`          | Removes all old generations (`nh clean all`)                                                  |
| `dots`            | `cd` into the repo                                                                            |
| `init <template>` | Starts a dev environment in the current folder: `c`, `py`, `rs`, `js`/`ts`                    |

`rebuild` picks the config matching the machine's hostname. To build or switch to another one, name it: `nh os build -H framework-intel` (needed once on the Intel Framework board, with `nh os switch`, while its hostname is still `framework`).

`flake.lock` is updated by a GitHub Action every Monday. The PR auto-merges once every host builds in CI, so prefer `update` over running `nix flake update` locally.

## Additional Setup

### Tailscale

1. Run `sudo tailscale up` and log in
2. SSH on the Framework hosts is only open on the Tailscale interface, so connect with the Tailscale name or IP (`ssh appleboblin@framework`). The desktop also accepts SSH on the LAN

### fcitx5

1. Add Chewing and set English (US) as the base layout
2. On the Framework (kanata): hold `RAlt` and press `2` to switch to the QWERTY layer before typing in Chewing

### PCloud

1. Log in and set the sync folder
2. Set up Cryptomator to unlock the encrypted folders if needed
