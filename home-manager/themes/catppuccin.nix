{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.catppuccin) flavor accent;
  cap = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
in
{
  _module.args.ctp = {
    inherit flavor accent cap;
    Flavor = cap flavor;
    Accent = cap accent;
  };

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
    package = pkgs.catppuccin-cursors."${flavor}${cap accent}";
    name = "catppuccin-${flavor}-${accent}-cursors";
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };
}
