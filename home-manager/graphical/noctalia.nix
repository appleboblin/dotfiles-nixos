{
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  # services.playerctld.enable = true;
  programs.noctalia = {
    enable = true;
    # settings = {
    #   general = {
    #     enableShadows = false;
    #   };
    #   # configure noctalia here
    #   bar = {
    #     barType = "simple";
    #     density = "default"; # compact
    #     position = "top";
    #     showCapsule = false;
    #     widgets = {
    #       left = [
    #         {
    #           id = "ControlCenter";
    #           useDistroLogo = true;
    #         }
    #         {
    #           id = "Network";
    #         }
    #         {
    #           id = "Bluetooth";
    #         }
    #       ];
    #       center = [
    #         {
    #           hideUnoccupied = false;
    #           id = "Workspace";
    #           labelMode = "none";
    #         }
    #       ];
    #       right = [
    #         {
    #           alwaysShowPercentage = true;
    #           id = "Battery";
    #           warningThreshold = 30;
    #         }
    #         {
    #           formatHorizontal = "HH:mm";
    #           formatVertical = "HH mm";
    #           id = "Clock";
    #           useMonospacedFont = true;
    #           usePrimaryColor = true;
    #         }
    #       ];
    #     };
    #   };
    #   colorSchemes.predefinedScheme = "Monochrome";
    #   osd = {
    #     location = "bottom_center";
    #   };
    #   location = {
    #     monthBeforeDay = true;
    #     name = "Oregon, United States";
    #   };
    #   wallpaper = {
    #     enabled = true;
    #     # default.path = "${./WP_Laser_Up-2560x1440_00229.jpg}";
    #   };
    # };
    # this may also be a string or a path to a JSON file.
  };

  # home.file.".cache/noctalia/wallpapers.json" = {
  #   text = builtins.toJSON {
  #     defaultWallpaper = "${./WP_Laser_Up-2560x1440_00229.jpg}";
  #     # wallpapers = {
  #     #   "DP-1" = "/path/to/monitor/wallpaper.png";
  #     # };
  #   };
  # };
}
