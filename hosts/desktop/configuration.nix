# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  host,
  lib,
  pkgs,
  ...
}:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = host; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set lightdm wallpaper
  # services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
  #   font-name = Inter 16
  #   background=${./framework_wallpaper.png}
  # '';

  # bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = lib.mkForce true; # powers up the default Bluetooth controller on boot
  };
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.appleboblin = {
    packages = with pkgs; [

    ];
  };

  # Xone kernel driver for xbox controller
  hardware.xone.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  hm.xdg.configFile."hypr/hyprpaper.conf".text = lib.mkIf config.programs.hyprland.enable ''
    		wallpaper = DP-1,${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
    		wallpaper = DP-2,${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
    		wallpaper = HDMI-A-1,${../../home-manager/hyprland/WP_Laser_Up-2560x1440_00229.jpg}
    	'';

  # Hyprland settings
  hm.wayland.windowManager.hyprland.settings = lib.mkIf config.programs.hyprland.enable {
    monitor = [
      "DP-2, 2560x1440@165, 0x0, 1"
      "DP-1, 2560x1440@165, 2560x0, 1"
      "HDMI-A-1, 1920x1080@60, 5120x-133, 1, transform, 3"
    ];

    workspace = [
      "1, monitor:DP-2, layoutopt:orientation:left, default:true"
      "2, monitor:DP-2, layoutopt:orientation:left"
      "3, monitor:DP-2, layoutopt:orientation:left"
      "4, monitor:DP-1, layoutopt:orientation:left, default:true"
      "5, monitor:DP-1, layoutopt:orientation:left"
      "6, monitor:DP-1, layoutopt:orientation:left"
      "7, monitor:DP-1, layoutopt:orientation:left"
      "8, monitor:HDMI-A-1, layoutopt:orientation:top"
      "9, monitor:HDMI-A-1, layoutopt:orientation:top"
      "10, monitor:HDMI-A-1, layoutopt:orientation:top, default:true"
    ];

    exec-once = [
      "sleep 3;hyprctl dispatch workspace 1;hyprctl dispatch workspace 10;hyprctl dispatch workspace 9;hyprctl dispatch workspace 4"
    ];
  };
}
