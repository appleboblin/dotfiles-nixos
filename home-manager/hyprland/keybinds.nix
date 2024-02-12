{
    config,
    pkgs,
    lib,
    host,
    isLaptop,
    inputs,
    ...
}: {
    wayland.windowManager.hyprland.settings = {
        # press and hold
        binde = [
            # Adjust volume
            ", XF86AudioRaiseVolume, exec, ${lib.getExe pkgs.pamixer} -i 5"
            ", XF86AudioLowerVolume, exec, ${lib.getExe pkgs.pamixer} -d 5"

            # Adjust screen brightness
            ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set 5%+"
            ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"

            # Resize window
            "$mod SHIFT, right, resizeactive, 10 0"
            "$mod SHIFT, left, resizeactive, -10 0"
            "$mod SHIFT, up, resizeactive, 0 -10"
            "$mod SHIFT, down, resizeactive, 0 10"
        ];

        # Laptop lid
        bindl = lib.mkIf isLaptop [
            ",switch:Lid Switch, exec, ${pkgs.systemd}/bin/systemctl suspend"
        ];

        # Activate when release
        bindr = [
            
        ];
        bind = [
            # Media keys
            ", XF86AudioMute, exec, ${lib.getExe pkgs.pamixer} -t"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"

            "$mod, Return, exec, kitty"
            "$mod, W, killactive"
            "ALT, Return, togglespecialworkspace, scratchpad"
            "ALT, S, togglespecialworkspace, music"

            # Screenshot
            "$mod SHIFT, S, exec, grimblast --notify --cursor copysave area ~/Pictures/Screenshots/screenshot_$(date '+%Y%m%d_%H%M%S').png"
            ", Print, exec, pkill rofi || rofi-screenshot-menu"

            # toggle Menu
            "CTRL SHIFT, Delete, exec, pkill rofi || rofi-power-menu"
            "$mod, V, exec, pkill rofi || cliphist list | ${lib.getExe pkgs.rofi} -dmenu -p 'Select to copy' | cliphist decode | wl-copy" # Select from history
            "$mod SHIFT, V, exec, pkill rofi || cliphist list | ${lib.getExe pkgs.rofi} -dmenu -p 'Select to delete' | cliphist delete" # Select history to delete
            "$mod, Space, exec, pkill rofi || ${lib.getExe pkgs.rofi} -show drun"
            "$mod, C, exec, pkill rofi || rofi -show calc -modi calc -no-show-match -no-sort"

            # Delete last entry from cliphist history
            "$mod, Delete, exec, cliphist list | cliphist delete "

            # float and full
            "$mod, F, togglefloating"
            "$mod SHIFT, F, fullscreen"

            # Quit Hyprland
            "$mod ALT, F4, exit"
            # Mode focus
            "$mod, M, movefocus, l"
            "$mod, N, movefocus, d"
            "$mod, E, movefocus, u"
            "$mod, I, movefocus, r"

            # Move window
            "$mod SHIFT, M, movewindow, l"
            "$mod SHIFT, N, movewindow, d"
            "$mod SHIFT, E, movewindow, u"
            "$mod SHIFT, I, movewindow, r"

            # Switch workspace
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"
            "$mod, left, workspace, -1"
            "$mod, right, workspace, +1"
            "$mod, up, workspace, m+1"
            "$mod, down, workspace, m-1"

            # Move to workspace
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"
        ];

        bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
        ];
    };
}
