# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  host,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = host; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Set lightdm wallpaper
  services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
    font-name = Inter 16
    background=${./framework_wallpaper.png}
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.appleboblin = {
    packages = with pkgs; [
      fw-ectool
    ];
  };
  # qmk for linux
  services.keyd = {
    enable = true;
    keyboards.true = {
      ids = ["*"];
      settings = {
        main = {
          leftalt = "leftmeta";
          leftmeta = "leftalt";

          # Colemak
          s = "r";
          e = "f";
          d = "s";
          r = "p";
          f = "t";
          v = "d";
          t = "b";
          g = "g";
          b = "v";

          y = "j";
          h = "m";
          n = "k";
          u = "l";
          j = "n";
          m = "h";
          i = "u";
          k = "e";
          o = "y";
          l = "i";
          p = ";";
          ";" = "o";
        };
        qwerty = {
          # Qwerty
          s = "s";
          e = "e";
          d = "d";
          r = "r";
          f = "f";
          v = "v";
          t = "t";
          g = "g";
          b = "b";

          y = "y";
          h = "h";
          n = "n";
          u = "u";
          j = "j";
          m = "m";
          i = "i";
          k = "k";
          o = "o";
          l = "l";
          p = "p";
          ";" = ";";
        };
        "control+shift" = {
          space = "toggle(qwerty)";
        };

      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # enable battery for waybar
  # config.appleboblin.battery.enable = true;

  hm.xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
    wallpaper = eDP-1,${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
  '';

  # Hyprland settings
  hm.wayland.windowManager.hyprland.settings = lib.mkIf config.programs.hyprland.enable {
      monitor = [
      "eDP-1, 2256x1504, 0x0, 1"
      ];

      workspace = [
          "1, monitor:eDP-1, default:true"
          "2, monitor:eDP-1"
          "3, monitor:eDP-1"
          "4, monitor:eDP-1"
          "5, monitor:eDP-1"
          "6, monitor:eDP-1"
          "7, monitor:eDP-1"
          "8, monitor:eDP-1"
          "9, monitor:eDP-1"
          "10, monitor:eDP-1"
      ];

      exec-once = [
          # brightness on startup
          "${lib.getExe pkgs.brightnessctl} s 40%"
      ];
  };
}
