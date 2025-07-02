{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # clipboard history
    cliphist
    wl-clipboard
  ];

  programs = {
    waybar.enable = true;
    hyprlock.enable = true;
  };

  services = {
    hypridle.enable = true;
    swaync.enable = true;
    swayosd.enable = true;
    wlsunset.enable = true;
    hyprpaper = {
      enable = true;
      settings = {
        preload = "${./WP_Laser_Up-2560x1440_00229.jpg}";
        splash = false;
      };
    };
  };
}
