{ config, pkgs, ... }:
let
  # umbriel-toggle-app <app-id> <launch command...>
  # if it's already focused, jump back to the previous window.
  umbriel-toggle-app = pkgs.writeShellApplication {
    name = "umbriel-toggle-app";
    runtimeInputs = [
      pkgs.jq
      config.programs.umbriel.package
    ];
    text = ''
      target_app="$1"; shift
      state="$XDG_RUNTIME_DIR/umbriel-toggle-app-$target_app"
      focused=$(umbriel focused-window --json 2>/dev/null || echo '{}')
      focused_app=$(jq -r '.app_id // empty' <<<"$focused")

      if [ "$focused_app" = "$target_app" ]; then
        if [ -f "$state" ]; then
          umbriel msg window-focus "$(<"$state")" >/dev/null 2>&1 || true
        fi
      else
        jq -r '.id // empty' <<<"$focused" > "$state"
        id=$(umbriel windows --json |
          jq -r --arg a "$target_app" 'first(.[] | select(.app_id == $a)) | .id // empty')
        if [ -n "$id" ]; then
          umbriel msg window-focus "$id" >/dev/null
        else
          exec "$@"
        fi
      fi
    '';
  };

  noctalia = args: "spawn noctalia msg ${args}";
  locked = action: {
    inherit action;
    allow_when_locked = true;
  };
  once = action: {
    inherit action;
    repeat = false;
  };

  workspaces = builtins.listToAttrs (
    builtins.concatMap (
      n:
      let
        key = toString n;
      in
      [
        {
          name = "Mod+${key}";
          value = "workspace-switch --name ${key}";
        }
        {
          name = "Mod+Shift+${key}";
          value = "window-move-to-workspace --name ${key}";
        }
      ]
    ) (builtins.genList (i: i + 1) 9)
  );
in
{
  home.packages = [ umbriel-toggle-app ];

  programs.umbriel.settings.keybinds = {
    # media / brightness (also work on the lock screen)
    "XF86AudioPlay" = locked (noctalia "media toggle");
    "XF86AudioStop" = locked (noctalia "media stop");
    "XF86AudioPrev" = locked (noctalia "media previous");
    "XF86AudioNext" = locked (noctalia "media next");
    "XF86AudioMute" = locked (noctalia "volume-mute");
    "XF86AudioRaiseVolume" = locked (noctalia "volume-up");
    "XF86AudioLowerVolume" = locked (noctalia "volume-down");
    "XF86MonBrightnessUp" = locked (noctalia "brightness-up");
    "XF86MonBrightnessDown" = locked (noctalia "brightness-down");

    # screenshots
    "Print" = noctalia "screenshot-region";
    "Mod+Shift+S" = noctalia "screenshot-region";
    "Shift+Print" = noctalia "screenshot-fullscreen";

    # shell
    "Mod+Space" = once (noctalia "panel-toggle launcher");
    "Mod+V" = noctalia "panel-toggle clipboard";
    "Shift+Ctrl+Delete" = noctalia "panel-toggle session";
    "Mod+Ctrl+L" = noctalia "session lock";
    "Mod+Shift+X" = "spawn loginctl lock-session";
    "Mod+Return" = once "spawn footclient";

    # apps
    "Mod+S" = once "spawn umbriel-toggle-app spotify spotify";
    "Mod+I" = once "spawn umbriel-toggle-app vesktop vesktop";

    # windows
    "Mod+Q" = once "window-close";
    "Mod+Shift+Q" = "session-quit";
    "Mod+G" = "window-cycle-primary-extent";
    "Mod+F" = once "window-toggle-maximize";
    "Mod+Shift+F" = once "window-toggle-fullscreen";
    "Mod+Ctrl+F" = once "window-toggle-floating";
    "Mod+Tab" = "window-focus-switch-floating";
    "Mod+W" = once "column-toggle-tabbed";
    "Mod+C" = "window-center";
    "Mod+O" = once "overview-toggle";
    "Mod+Period" = "window-consume-or-expel-left";
    "Mod+Minus" = "window-consume-or-expel-right";
    "Mod+Shift+P" = "window-consume-left";
    "Mod+Shift+K" = "window-consume-or-expel-right";

    # resize
    "Mod+Alt+Y" = "window-modify-primary-extent -0.1";
    "Mod+Alt+E" = "window-modify-primary-extent +0.1";
    "Mod+Shift+Alt+Y" = "window-modify-secondary-extent -0.1";
    "Mod+Shift+Alt+E" = "window-modify-secondary-extent +0.1";

    # focus
    "Mod+Y" = "window-focus-or-output-left";
    "Mod+E" = "window-focus-or-output-right";
    "Mod+H" = "window-focus-or-workspace-down";
    "Mod+A" = "window-focus-or-workspace-up";
    "Mod+Ctrl+Y" = "output-focus-left";
    "Mod+Ctrl+E" = "output-focus-right";
    "Mod+Ctrl+A" = "workspace-previous";
    "Mod+Ctrl+H" = "workspace-next";

    # move
    "Mod+Shift+Y" = "window-move-or-output-left";
    "Mod+Shift+E" = "window-move-or-output-right";
    "Mod+Shift+A" = "window-move-or-workspace-up";
    "Mod+Shift+H" = "window-move-or-workspace-down";
    "Mod+Shift+Ctrl+Y" = "window-move-to-output-left";
    "Mod+Shift+Ctrl+E" = "window-move-to-output-right";
    "Mod+Shift+Ctrl+A" = "window-move-to-workspace-previous";
    "Mod+Shift+Ctrl+H" = "window-move-to-workspace-next";

    # escape hatch for games / remote desktop that grab shortcuts
    "Mod+Shift+Escape" = {
      action = "shortcuts-inhibit-toggle";
      allow_when_inhibited = true;
      repeat = false;
    };

    "Mod+0" = "workspace-switch stuff";
    "Mod+Shift+0" = "column-move-to-workspace stuff";
  }
  // workspaces;
}
