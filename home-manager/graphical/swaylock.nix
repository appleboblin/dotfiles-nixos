{
  pkgs,
  lib,
  ...
}:
{
  programs.swaylock = {
    package = pkgs.swaylock-effects;
    settings = {
      image = lib.mkDefault "${./WP_Laser_Up-2560x1440_00229.jpg}";
      ignore-empty-password = true;
      show-failed-attempts = true;
      indicator-caps-lock = true;
      clock = true;

      font = "MesloLGS Nerd Font";
      font-size = 16;

      color = "1d1f21";
      indicator-idle-visible = true;
      indicator-radius = 150;
      indicator-thickness = 30;

      inside-color = "1d1f21bb";
      inside-clear-color = "1d1f21bb";
      inside-ver-color = "1d1f21bb";
      inside-wrong-color = "1d1f21bb";

      key-hl-color = "7aa6daaa";
      bs-hl-color = "d54e53aa";

      separator-color = "55555555";

      line-color = "1d1f21";
      line-uses-ring = true;

      text-color = "e5e9f0";
      text-clear-color = "b5bd68";
      text-caps-lock-color = "f0c674";
      text-ver-color = "e5e9f0";
      text-wrong-color = "cc6666";

      ring-color = "81a2be55";
      ring-ver-color = "81a2be";
      ring-clear-color = "b5bd6811";
      ring-wrong-color = "cc6666";
    };
  };
}
