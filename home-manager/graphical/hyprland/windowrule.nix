{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # do not idle while watching videos, not working for some reason
      "idleinhibit fullscreen, class:^(Brave-browser)$"
      "idleinhibit fullscreen, class:^(firefox)$"
      "idleinhibit focus, class:^(firefox)$,title:^(.*YouTube.*)$"
      "idleinhibit focus, class:^(YouTube)$"
      "idleinhibit focus, class:^(mpv)$"
      "workspace 10 silent, class:^(webcord)$"
      "workspace 10 silent, class:^(discord)$"
      "workspace 10 silent, class:^(vesktop)$"
      "workspace 9 silent, class:^(obsidian)$"
      "idleinhibit fullscreen, title:(.*?)" # dont block if any app is on fullscreen
      # "workspace special:ncspot silent, class:(kitty),title:(ncspot)"
      "opacity 0.8 0.8, class:(scratch)"
      # "opacity 0.8 0.8, workspace:-98"
      "opacity 0.8 0.8, initialTitle:^(Spotify)(.*)$"
      "workspace special:music silent, title:^(Spotify)(.*)$"
      # "workspace special:scratchpad silent, class:(scratchpad)"
      "workspace special:scratchpad silent, class:(scratch)"
      # "workspace special:scratchpad silent, class:(com.term.scratch)"
      # "workspace 1 silent, class(obsidian), title:(Obsidian)(.*)$"
      # "workspace 10 silent, class:(thunderbird), title:(Mozilla Thunderbird)(.*)$ "
    ];

    # layerrule = [
    # ];
  };
}
