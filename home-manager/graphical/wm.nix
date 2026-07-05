{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # clipboard history
    # cliphist
    # wl-clipboard
    # swaybg
  ];

  programs = {
    # waybar.enable = false;
    # hyprlock.enable = true;
  };

  services = {
    cliphist = {
      enable = false;
      allowImages = true;
    };
    hypridle.enable = false;
    # swaync.enable = true;
    # swayosd.enable = true;
    # wlsunset.enable = true;
  };
}
