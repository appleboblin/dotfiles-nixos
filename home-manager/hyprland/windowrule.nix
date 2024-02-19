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
            # do not idle while watching videos, not working for some reason
            "idleinhibit fullscreen, Brave-browser"
            "idleinhibit fullscreen, class:^(firefox)$"
            "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
            "idleinhibit focus, YouTube"
            "idleinhibit focus, mpv"
        ];

        windowrulev2 = [
            "idleinhibit fullscreen, title:(.*?)" # dont block if any app is on fullscreen
            # "workspace special:ncspot silent, class:(kitty),title:(ncspot)"
            "opacity 0.8 0.8, class:(scratch)"
            # "opacity 0.8 0.8, workspace:-98"
            "opacity 0.8 0.8, initialTitle:^(Spotify)(.*)$"
            "workspace special:music silent, title:^(Spotify)(.*)$"
            # "workspace special:scratchpad silent, class:(scratchpad)"
            "workspace special:scratchpad silent, class:(scratch)"
            # "workspace 1 silent, class(obsidian), title:(Obsidian)(.*)$"
            # "workspace 10 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
        ];

        # layerrule = [
        # ];
    };
}