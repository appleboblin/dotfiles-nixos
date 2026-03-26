{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # clipboard history
    cliphist
    wl-clipboard
    swaybg
  ];

  programs = {
    waybar.enable = true;
    hyprlock.enable = true;
  };

  services = {
    cliphist = {
      enable = true;
      allowImages = true;
    };
    hypridle.enable = true;
    swaync.enable = true;
    swayosd.enable = true;
    wlsunset.enable = true;
  };
}
