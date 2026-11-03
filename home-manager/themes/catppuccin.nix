{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.catppuccin) flavor accent;
  capitalize = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
in
{
  catppuccin = {
    autoEnable = true;
    enable = true;
    flavor = "macchiato";
    accent = "pink";

    foot.enable = false;
    cursors.enable = false;
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.catppuccin-cursors."${flavor}${capitalize accent}";
    name = "catppuccin-${flavor}-${accent}-cursors";
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };
}
