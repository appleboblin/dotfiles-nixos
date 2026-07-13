# appleboblin's NixOS Config

## Features

- Multiple NixOS host machine configuration
- Niri with noctalia shell
- Catppuccin Macchiato (Pink accent) theme

## How to Install

Run the command below from a terminal on a NixOS live ISO, or from a TTY on the minimal ISO. The script creates the disk partitions, sets the necessary flags, and installs NixOS

```sh
sh <(curl -L https://raw.githubusercontent.com/appleboblin/dotfiles-nixos/refs/heads/main/install.sh)
```

## Adding a New Host

1. Create a directory in `hosts/` named after the new hostname, following the same layout as the existing hosts
2. Boot the new machine into the live ISO and run:

   ```sh
   nixos-generate-config --no-filesystems --show-hardware-config
   ```

3. Copy the output to a pastebin or similar, and use it to replace the contents of `hosts/NEW_HOSTNAME/hardware.nix` — preferably from another machine
4. Push the updated config, then follow [How to Install](https://github.com/appleboblin/dotfiles-nixos/#how-to-install) above

## Additional Setup

### fcitx5

1. Add Chewing and set English (US) as the base layout
2. Hold `RAlt` and press `2` to switch to QWERTY layer before typing in Chewing

### Protonmail Bridge

1. Kill the running bridge process.
2. Launch the app in terminal: `protonmail-bridge -c`
3. Run `login` and authenticate. Syncing starts once authentication completes
4. After syncing finishes, run `info` and add the printed credentials to Thunderbird

### PCloud

1. Log in and set the sync folder
2. Set up Cryptomator to unlock the encrypted folders if needed
