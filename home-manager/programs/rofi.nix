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
    font = "MesloLGS Nerd Font 16";
    extraConfig = {
      display-drun = " ";
      drun-display-format = "{name}";
      show-icons = true;
      modi = "window,run,drun";
    };
    # plugins = with pkgs; [
    #     rofi-calc
    # ];
    theme = {
      "*" = {
        nord0 = mkLiteral "#2e3440";
        nord1 = mkLiteral "#3b4252";
        nord2 = mkLiteral "#434c5e";
        nord3 = mkLiteral "#4c566a";

        nord4 = mkLiteral "#d8dee9";
        nord5 = mkLiteral "#e5e9f0";
        nord6 = mkLiteral "#eceff4";

        nord7 = mkLiteral "#8fbcbb";
        nord8 = mkLiteral "#88c0d0";
        nord9 = mkLiteral "#81a1c1";
        nord10 = mkLiteral "#5e81ac";
        nord11 = mkLiteral "#bf616a";

        nord12 = mkLiteral "#d08770";
        nord13 = mkLiteral "#ebcb8b";
        nord14 = mkLiteral "#a3be8c";
        nord15 = mkLiteral "#b48ead";

        fg = mkLiteral "@nord9";
        backlight = mkLiteral "#ccffeedd";
        background-color = mkLiteral "transparent";

        background-alt = mkLiteral "#383e4a";

        highlight = mkLiteral "underline bold #eceff4";

        transparent = mkLiteral "rgba(46,52,64,0)";

        border = mkLiteral "0";
        margin = mkLiteral "0";
        padding = mkLiteral "0";
        spacing = mkLiteral "0";
      };

      "window" = {
        width = "30%";
        # location = mkLiteral "center";
        # anchor = mkLiteral "center";
        background-color = mkLiteral "@nord1";
      };

      "mainbox" = {
        children = mkLiteral "[ inputbar, listview ]";
        background-color = mkLiteral "@nord1";
      };

      "inputbar" = {
        # color = mkLiteral "@nord11";
        # padding = mkLiteral "11px";
        background-color = mkLiteral "@nord9";
        children = mkLiteral "[prompt, entry]";
      };

      "prompt" = {
        # margin = mkLiteral "0px 1em 0em 0em";
        enabled = true;
        padding = mkLiteral "12 0 0 12";
        backgrouond-color = mkLiteral "@nord1";
        text-color = mkLiteral "@nord6";
      };

      "entry" = {
        # margin = mkLiteral "0px 1em 0em 0em";
        padding = mkLiteral "12";
        backgrouond-color = mkLiteral "@nord1";
        text-color = mkLiteral "@nord6";
      };

      "listview" = {
        background-color = mkLiteral "@nord1";
        columns = 1;
        lines = 6;
      };

      "element" = {
        padding = mkLiteral "8 12";
        backgrouond-color = mkLiteral "@background-color";
        text-color = mkLiteral "@nord9";
      };

      "element selected" = {
        background-color = mkLiteral "@background-color";
        text-color = mkLiteral "@nord6";
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
