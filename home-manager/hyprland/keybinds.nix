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
        bind = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
            "$mod, Return, exec, kitty"
            "$mod, W, killactive"
            "ALT, SPACE, togglespecialworkspace, scratchpad"
            "ALT, S, togglespecialworkspace, ncspot"

            # Switch input
            "$mod ALT, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next"

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
