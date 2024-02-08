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
        windowrule = [
            # do not idle while watching videos
            "idleinhibit fullscreen, Brave-browser"
            "idleinhibit fullscreen, class:^(firefox)$"
            "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
            "idleinhibit focus, mpv"
            # "workspace 9 silent, WebCord"
        ];

        windowrulev2 = [
            # "workspace special:ncspot silent, class:(kitty),title:(ncspot)"
            "opacity 0.8 0.8, title:(Spotify Premium)"
            "workspace special:music silent, stitle:(Spotify Premium)"
            "workspace special:scratchpad silent, class:(scratchpad)"
            # "workspace 1 silent, class(obsidian), title:(Obsidian)(.*)$"
            # "workspace 10 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
        ];

        # layerrule = [
        # ];
    };
}