{
  config,
  host,
  lib,
  pkgs,
  nix-your-shell,
  ...
}:
let
  monitors = import ./monitors.nix;
  wpPath = ../../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg;
in
{
  nixpkgs.overlays = [
    nix-your-shell.overlays.default
  ];

  networking.hostName = host;
  hardware = {
    graphics = {
      enable = true;
      # opencl
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
      # vulkan
      enable32Bit = true;
    };

    # bluetooth
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = lib.mkForce true; # powers up the default Bluetooth controller on boot
    };

    # Xone kernel driver for xbox controller
    xone.enable = true;
  };

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment.systemPackages = with pkgs; [
    lact
    amdgpu_top
  ];

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  services.blueman.enable = true;
  services.hardware.bolt.enable = true;

  # Desktop environment
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  hm = {
    services.hyprpaper.settings = {
      wallpaper = [
        "${monitors.left},${wpPath}"
        "${monitors.middle},${wpPath}"
        "${monitors.right},${wpPath}"
      ];
    };

    # Hyprland settings
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "${monitors.left}, 2560x1440@165, 0x0, 1"
        "${monitors.middle}, 2560x1440@165, 2560x0, 1"
        "${monitors.right}, 1920x1080@60, 5120x-133, 1, transform, 3"
      ];

      workspace = [
        "1, monitor:${monitors.left}, layoutopt:orientation:left, default:true"
        "2, monitor:${monitors.left}, layoutopt:orientation:left"
        "3, monitor:${monitors.left}, layoutopt:orientation:left"
        "4, monitor:${monitors.middle}, layoutopt:orientation:left, default:true"
        "5, monitor:${monitors.middle}, layoutopt:orientation:left"
        "6, monitor:${monitors.middle}, layoutopt:orientation:left"
        "7, monitor:${monitors.middle}, layoutopt:orientation:left"
        "8, monitor:${monitors.right}, layoutopt:orientation:top"
        "9, monitor:${monitors.right}, layoutopt:orientation:top"
        "10, monitor:${monitors.right}, layoutopt:orientation:top, default:true"
      ];

      exec-once = [
        "sleep 3;hyprctl dispatch workspace 1;hyprctl dispatch workspace 10;hyprctl dispatch workspace 9;hyprctl dispatch workspace 4"
      ];
    };
  };
}
