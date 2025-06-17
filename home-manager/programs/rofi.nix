{
  config,
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  rofi-power-menu = pkgs.writeShellApplication {
    name = "rofi-power-menu";
    runtimeInputs = with pkgs; [
      rofi-wayland
      procps
    ];
    text = lib.readFile ./rofi-power-menu.sh;
  };
  rofi-wifi-menu = pkgs.writeShellApplication {
    name = "rofi-wifi-menu";
    runtimeInputs = with pkgs; [
      rofi-wayland
      libnotify
      networkmanager
    ];
    text = lib.readFile ./rofi-wifi-menu.sh;
  };
  rofi-screenshot-menu = pkgs.writeShellApplication {
    name = "rofi-screenshot-menu";
    runtimeInputs = with pkgs; [
      rofi-wayland
      libnotify
      grimblast
    ];
    text = lib.readFile ./rofi-screenshot-menu.sh;
  };
in
{
  programs.rofi = {
    enable = host != "vm";
    package = pkgs.rofi-wayland;
    font = "Inter Nerd Font Regular 16";
    extraConfig = {
      display-drun = " ";
      drun-display-format = "{name}";
      display-window = " ";
      display-run = " ";
      show-icons = true;
      modi = "window,run,drun";
    };
    # plugins = with pkgs; [
    #     rofi-calc
    # ];
    theme = {
      "*" = {
        rosewater = mkLiteral "#f4dbd6";
        flamingo = mkLiteral "#f0c6c6";
        pink = mkLiteral "#f5bde6";
        mauve = mkLiteral "#c6a0f6";
        red = mkLiteral "#ed8796";
        maroon = mkLiteral "#ee99a0";
        peach = mkLiteral "#f5a97f";
        yellow = mkLiteral "#eed49f";
        green = mkLiteral "#a6da95";
        teal = mkLiteral "#8bd5ca";
        sky = mkLiteral "#91d7e3";
        sapphire = mkLiteral "#7dc4e4";
        blue = mkLiteral "#8aadf4";
        lavender = mkLiteral "#b7bdf8";

        text = mkLiteral "#cad3f5";
        subtext1 = mkLiteral "#b8c0e0";
        subtext0 = mkLiteral "#a5adcb";

        overlay2 = mkLiteral "#939ab7";
        overlay1 = mkLiteral "#8087a2";
        overlay0 = mkLiteral "#6e738d";

        surface2 = mkLiteral "#5b6078";
        surface1 = mkLiteral "#494d64";
        surface0 = mkLiteral "#363a4f";

        base = mkLiteral "#24273a";
        mantle = mkLiteral "#1e2030";
        crust = mkLiteral "#181926";

        fg = mkLiteral "@pink";
        backlight = mkLiteral "@maroon";
        background-color = mkLiteral "transparent";

        background-alt = mkLiteral "@surface1";

        highlight = mkLiteral "underline bold #fbdbe6";

        transparent = mkLiteral "rgba(46,52,64,0)";
        mauve-transparent = mkLiteral "rgba(198,160,246,0.2)";

      };

      "window" = {
        width = "30%";
        # location = mkLiteral "center";
        # anchor = mkLiteral "center";
        background-color = mkLiteral "@surface0";
        border = mkLiteral "2";
        border-radius = mkLiteral "10";
        border-color = mkLiteral "@pink";
      };

      "mainbox" = {
        children = mkLiteral "[ inputbar, listview ]";
        background-color = mkLiteral "@surface0";
      };

      "inputbar" = {
        color = mkLiteral "@crust";
        # padding = mkLiteral "11px";
        background-color = mkLiteral "@surface1";
        children = mkLiteral "[prompt, entry]";
      };

      "prompt" = {
        # margin = mkLiteral "0px 1em 0em 0em";
        enabled = true;
        padding = mkLiteral "12 0 0 12";
        backgrouond-color = mkLiteral "@surface0";
        text-color = mkLiteral "@pink";
      };

      "entry" = {
        # margin = mkLiteral "0px 1em 0em 0em";
        padding = mkLiteral "12";
        backgrouond-color = mkLiteral "@surface0";
        text-color = mkLiteral "@text";
      };

      "listview" = {
        background-color = mkLiteral "@surface0";
        columns = 1;
        lines = 6;
      };

      "element" = {
        padding = mkLiteral "8 12";
        backgrouond-color = mkLiteral "@background-color";
        text-color = mkLiteral "@text";
      };

      "element selected" = {
        background-color = mkLiteral "@mauve-transparent";
        text-color = mkLiteral "@mauve";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };

      "element-icon" = {
        size = mkLiteral "14";
        padding = mkLiteral "0 10 0 0";
        background-color = mkLiteral "transparent";
      };
    };
  };
  home.packages = [
    rofi-power-menu
    rofi-wifi-menu
    rofi-screenshot-menu
  ];

  # xdg.configFile = {
  #     "rofi/rofi-wifi-menu" = {
  #     # https://github.com/ericmurphyxyz/rofi-wifi-menu/blob/master/rofi-wifi-menu.sh
  #     source = ./rofi-wifi-menu.sh;
  #     executable = true;
  #     };
  # };
}
