# Keybinds

[← README](../README.md)

`Mod` is the Super key. Most binds are in `home-manager/graphical/umbriel/keybinds.nix`. A few only exist on the laptop and live in `hosts/framework/`.

The direction keys are Y, H, A, and E, for left, down, up, and right. On the laptop's Graphite layout, those letters sit where `h j k l` are on a QWERTY keyboard, so they work like Vim's arrow keys. On a QWERTY keyboard they're just letters.

## Apps and the shell

| Keys                   | What it does                                           |
| ---------------------- | ------------------------------------------------------ |
| `Mod+Return`           | Opens a terminal                                       |
| `Mod+Space`            | Opens the launcher                                     |
| `Mod+V`                | Opens clipboard history                                |
| `Mod+S`                | Jumps to Spotify, starting it if needed. Press again to jump back. |
| `Mod+I`                | Jumps to Vesktop, starting it if needed. Press again to jump back. |
| `Mod+T`                | Shows or hides the scratchpad terminal                 |
| `Mod+Shift+T`          | Moves the current window into or out of the scratchpad |
| `Mod+Ctrl+T`           | Switches to the next window in the scratchpad          |
| `Mod+Ctrl+L`           | Locks the screen with Noctalia                         |
| `Mod+Shift+X`          | Locks the screen with `loginctl`                       |
| `Shift+Ctrl+Delete`    | Opens the session menu                                 |
| `Mod+Shift+Q`          | Quits Umbriel                                          |
| `Print` or `Mod+Shift+S` | Takes a screenshot of a region                       |
| `Shift+Print`          | Takes a screenshot of the whole screen                 |

The media, volume, and brightness keys go through Noctalia. They work on the lock screen too.

## Windows

| Keys                       | What it does                                         |
| -------------------------- | ---------------------------------------------------- |
| `Mod+Q`                    | Closes the window                                    |
| `Mod+F`                    | Maximizes the window                                 |
| `Mod+Shift+F`              | Makes the window fullscreen                          |
| `Mod+Ctrl+F`               | Switches the window between floating and tiled       |
| `Mod+Tab`                  | Moves focus between floating and tiled windows       |
| `Mod+C`                    | Centers the window                                   |
| `Mod+G`                    | Cycles the column width through 25%, 33%, 50%, and 100% |
| `Mod+W`                    | Turns tabs on or off for the column                  |
| `Mod+O`                    | Opens the overview                                   |
| `Mod+Period`               | Moves the window into the column on its left, or out of its column |
| `Mod+Minus` or `Mod+Shift+K` | Does the same toward the right                     |
| `Mod+Shift+P`              | Moves the window into the column on its left         |

### Moving focus and windows

| Keys                        | What it does                                                         |
| --------------------------- | -------------------------------------------------------------------- |
| `Mod+Y` and `Mod+E`         | Focus the window to the left or right. At the edge, focus moves to the next monitor. |
| `Mod+H` and `Mod+A`         | Focus the window below or above. At the edge, focus moves to the next workspace. |
| `Mod+Ctrl+Y` and `Mod+Ctrl+E` | Focus the monitor to the left or right                             |
| `Mod+Ctrl+H` and `Mod+Ctrl+A` | Go to the next or previous workspace                               |
| `Mod+Shift+Y` and `Mod+Shift+E` | Move the window left or right, onto the next monitor at the edge |
| `Mod+Shift+H` and `Mod+Shift+A` | Move the window down or up, onto the next workspace at the edge  |
| `Mod+Shift+Ctrl+Y` and `Mod+Shift+Ctrl+E` | Move the window to the monitor on the left or right    |
| `Mod+Shift+Ctrl+H` and `Mod+Shift+Ctrl+A` | Move the window to the next or previous workspace      |

### Resizing

| Keys                                | What it does                     |
| ----------------------------------- | -------------------------------- |
| `Mod+Alt+Y` and `Mod+Alt+E`         | Make the window 10% narrower or wider |
| `Mod+Shift+Alt+Y` and `Mod+Shift+Alt+E` | Make the window 10% shorter or taller |

### Workspaces

| Keys                        | What it does                          |
| --------------------------- | ------------------------------------- |
| `Mod+1` to `Mod+9`          | Go to workspace 1 to 9                |
| `Mod+Shift+1` to `Mod+Shift+9` | Move the window to workspace 1 to 9 |
| `Mod+0`                     | Go to the `stuff` workspace           |
| `Mod+Shift+0`               | Move the column to `stuff`            |

Vesktop, Element, and Spotify always open on `stuff`. They open maximized and don't steal focus.

### When shortcuts stop working

Some games and remote desktop apps grab the keyboard, and then Umbriel's shortcuts stop working. Press `Mod+Shift+Escape` to get them back. Press it again to let the app grab the keyboard again.

## Laptop only

| Keys             | What it does                                                          |
| ---------------- | --------------------------------------------------------------------- |
| `Mod+P`          | Switches presentation mode between off, extend, and mirror. See [the Framework page](framework.md#presentation-mode). |
| `XF86AudioMedia` | Opens a terminal. This is the Framework's media key.                  |

## kanata (Framework built-in keyboard)

kanata only changes the laptop's own keyboard. External keyboards work normally. The config is in `hosts/framework/kanata.nix`.

The default layer is the Graphite layout (angle mod variant). A few other keys change too:

- Shift on `'`, `,`, `-`, and `/` types `_`, `?`, `"`, and `<`, the way Graphite expects.
- Caps Lock acts as Control.
- Left Super and Left Alt are swapped.
- `Ctrl+Q` sends `Ctrl+.` instead. This happens in both layouts.

Tapping Right Alt types Right Alt as usual. Holding it opens a layer for switching layouts and using arrow keys:

| While holding Right Alt                 | What it does                              |
| --------------------------------------- | ----------------------------------------- |
| `1`                                     | Switches to Graphite                      |
| `2`                                     | Switches to QWERTY. Use this for Chewing. |
| The keys where `h j k l` are on QWERTY  | Arrow keys: left, down, up, right         |
| Caps Lock                               | A real Caps Lock                          |
