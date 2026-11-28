# Troubleshooting

[← README](../README.md)

## Rebuilds

If a new file doesn't seem to do anything, git probably isn't tracking it yet. Flakes ignore untracked files. `rebuild` runs `git add -A` for you, but with `nix build` or `nixos-rebuild` you need to `git add` the file yourself.

`rebuild` always builds the machine you're on. To build another host, run `nh os build -H framework-intel`, or `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`.

If Home Manager finds a file it didn't create where it wants to write, it renames that file to end in `.bak` and carries on. Check the `.bak` file and delete it when you're done.

## Umbriel

These commands help when something in Umbriel looks wrong.

| To do this                                  | Run                                                   |
| ------------------------------------------- | ----------------------------------------------------- |
| Check the config that's running             | `umbriel config validate --json`                      |
| Check a config before switching to it       | `umbriel config validate -c <path>`                   |
| See config reloads and errors               | `journalctl --user -b \| grep -i umbriel`             |
| List windows with their app ID, title, and monitor | `umbriel windows --json`                       |
| List monitors                               | `umbriel outputs --json`                              |
| Watch changes as they happen                | `umbriel subscribe outputs`, or `windows`, or `workspaces` |
| List every config option                    | `umbriel config schema --json`                        |

Umbriel reloads its config by itself after you switch, so you don't need to log out. When a reload works, the log says `config reloaded`.

You can try out a config without switching to it. Load the test copy, then load your normal config again when you're done:

```sh
umbriel config-replace /absolute/path/to/test.toml
umbriel config-replace ~/.config/umbriel/config.toml
```

Some warnings in the log are harmless. `Could not resolve keysym XF86...` comes from Xwayland, and the log itself says it isn't fatal. The Java `WARNING` lines come from Cryptomator.

Window rules match on `app_id` or `title`, and both are regular expressions. `umbriel windows --json` shows the values to match. Umbriel checks the rules again whenever a window's title changes.

## wl-mirror windows

Presentation mode works around two things Umbriel does with wl-mirror. Keep them in mind before simplifying `hosts/framework/present.nix`.

The first is that a wl-mirror window gets no picture if it opens without focus. With `default_focused = false` in its window rule, it stays black until you click it. The script lets the window take focus when it opens and then gives focus back to the window you were using.

The second is that Umbriel ignores wl-mirror's `--fullscreen-output` option. The mirror would open fullscreen on the laptop screen instead of the external display. To get around this, the script puts the display's name in the window title, like `present-mirror DP-2`. There's one window rule for each display name, and it sends the window to that display. If a dock or adapter uses a name that isn't in the `connectors` list in `present.nix`, mirror mode opens on the laptop screen. Add the name to the list to fix it.

wl-mirror picks how to capture the screen by itself. It only captures a new frame when the screen changes, so a slide that isn't moving costs almost nothing.

If presentation mode misbehaves, these commands show what's going on:

```sh
present status
systemctl --user status present-mirror present-watch
cat $XDG_RUNTIME_DIR/present-mode
journalctl --user -u present-mirror -u present-watch -b
present off          # resets everything
```

To watch wl-mirror itself, run it by hand with `-v`. Give it a title that no window rule matches, so the rules stay out of the way:

```sh
wl-mirror -v --title test DP-2
```

## Noctalia

`noctalia msg --help` lists every command Noctalia accepts, such as caffeine, Do Not Disturb, panels, media, and session. The keybinds and scripts in this repo use the same commands.

## Workarounds in the config

These parts of the config look odd, but they're there on purpose.

| Where                                    | Workaround                                                              |
| ---------------------------------------- | ----------------------------------------------------------------------- |
| `nixos/default.nix`, gvfs                | Forces `pkgs.gnome.gvfs`. The default package gave a gvfs error.        |
| `nixos/default.nix`, udev                | `uaccess` rules in a `70-` file. They must load before `73-seat-late.rules`, and `extraRules` loads too late. |
| `home-manager/default.nix`, Orca Slicer  | WebKit rendering workarounds, plus Python on `PATH`.                    |
| `hosts/framework/configuration.nix`      | Restarts `fprintd` after resume. The reader stops responding after suspend otherwise. |
| `hosts/framework/bluetooth-power.nix`    | Captures `bluetoothctl show` before `grep -q`. Piping it directly can cause SIGPIPE under `pipefail`. |
| `hosts/framework/low-battery-shutdown.nix`, fprintd restart | Uses `systemd-run --on-active`. Calling suspend or restart directly from inside `suspend.target` fails. |
| `hosts/desktop/configuration.nix`        | Ollama removed from `wantedBy`. Only runs when started by hand.         |
