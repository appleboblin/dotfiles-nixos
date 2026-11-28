# appleboblin's NixOS Config

This is the NixOS config for all my machines. It's a single flake that uses Home Manager as a NixOS module. Every machine runs the Umbriel compositor with the Noctalia shell, has ZFS as its root filesystem, and uses the Catppuccin Macchiato theme with a pink accent.

| Host              | Machine                                | Notes                                                       |
| ----------------- | -------------------------------------- | ----------------------------------------------------------- |
| `desktop`         | AMD desktop with two monitors          | Gaming, Ollama, wake-on-LAN                                 |
| `framework`       | Framework 13 with the Ryzen 7040 board | My laptop                                                   |
| `framework-intel` | Framework 13 with the Intel 12th-gen board | Not used yet. It's for when the old board gets its own case. |

## Documentation

| Page                                       | What it covers                                                     |
| ------------------------------------------ | ------------------------------------------------------------------ |
| [Repo layout](docs/layout.md)              | How a host is built, where settings go, and how to add a host      |
| [Keybinds](docs/keybinds.md)               | Umbriel shortcuts and the kanata layers on the laptop              |
| [Framework laptop](docs/framework.md)      | Presentation mode, battery and sleep, Bluetooth, and pCloud        |
| [Desktop](docs/desktop.md)                 | Monitors, idle settings, Ollama, gaming, and wake-on-LAN           |
| [CI and updates](docs/ci.md)               | GitHub Actions, weekly updates, and the rules on `main`            |
| [Troubleshooting](docs/troubleshooting.md) | Known quirks and how to debug them                                 |

## Features

- Three hosts in one flake. Both Framework boards share the same directory.
- ZFS root and zram swap, set up by a guided install script. The laptop's disk is encrypted.
- Umbriel with the Noctalia shell and greeter. Both come from binary caches, so nothing has to compile locally.
- `umbriel-toggle-app`, which jumps to an app with one key, starts it if needed, and jumps back on the next press.
- Catppuccin Macchiato in GTK, Qt, the terminal, and the editors.
- `nh` for rebuilds. It shows which packages changed and cleans up old generations.
- Dev shell templates (`init c`, `py`, `rs`, `js`) that load automatically with direnv.
- CI that builds every host for each pull request, checks formatting, and updates `flake.lock` every week.
- Laptop extras: presentation mode, the Graphite keyboard layout through kanata, a shutdown when the battery runs low during sleep, Bluetooth that stays on or off across reboots, and pCloud that only runs on Wi-Fi and AC power.
- Zed and Nixvim as editors.

## Install

> [!CAUTION]
> The install script **erases the disk you pick** and puts a ZFS pool on it.

Boot a NixOS live ISO and run this in a terminal. On the minimal ISO, run it from the TTY.

```sh
sh <(curl -L https://raw.githubusercontent.com/appleboblin/dotfiles-nixos/refs/heads/main/install.sh)
```

The script asks which disk to use. It creates a 1 GB boot partition called `NIXBOOT` and uses the rest for a ZFS pool called `NIXROOT`, with one dataset for `/` and one for `/home`. It asks whether to encrypt the pool, then asks for the flake URL, the host, and the git revision. After `nixos-install` finishes, it asks you to set a login password. If you skip that, the password is `password` until you change it with `passwd`.

Your answer about encryption has to match the host config. The Framework expects an encrypted pool and the desktop expects an unencrypted one. The setting is `boot.zfs.requestEncryptionCredentials`.

To install a machine that isn't in the flake yet, see [Adding a host](docs/layout.md#adding-a-host) first.

## Usage

| Command           | What it does                                                                         |
| ----------------- | ------------------------------------------------------------------------------------ |
| `rebuild`         | Formats the repo, stages all changes, and switches with `nh`. It shows a diff and asks first. |
| `update`          | Pulls the latest `main`, including the tested `flake.lock`, and rebuilds              |
| `garbage`         | Deletes generations older than 14 days but always keeps the newest 5                 |
| `delete`          | Deletes all old generations                                                          |
| `dots`            | Goes to the repo                                                                     |
| `gt [repo]`       | Goes to `~/github`, or to a repo inside it. Repo names tab-complete.                 |
| `init <template>` | Sets up a dev environment in the current folder. Templates are `c`, `py`, `rs`, `js`, and `ts`. |

`rebuild` uses the config that matches the machine's hostname. To build a different one, pass its name, as in `nh os build -H framework-intel`. The first time you install the Intel board, its hostname will still be `framework`, so switch to the right config once with `nh os switch -H framework-intel`.

A flake can only see files that git tracks. `rebuild` stages everything for you, but if you run `nix build` yourself, `git add` new files first.

CI updates `flake.lock` every Monday and merges it once every host builds. Use `update` to get it instead of running `nix flake update` yourself. [CI and updates](docs/ci.md) has the details.

## After installing

### Tailscale

1. Run `sudo tailscale up` and log in.
2. The laptop only accepts SSH over Tailscale, so connect with its Tailscale name or IP, for example `ssh appleboblin@framework`. The desktop also accepts SSH from the local network. Both only allow key login.

### fcitx5

1. Add Chewing and set English (US) as the base layout.
2. On the Framework, switch kanata to QWERTY before typing in Chewing. Hold `RAlt` and press `2`.

### pCloud

1. Log in and pick the sync folder.
2. If you need the encrypted folders, set up Cryptomator to unlock them.
