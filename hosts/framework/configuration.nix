{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  wpPath = ../../home-manager/graphical/WP_Laser_Up-2560x1440_00229.jpg;
in
{
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
  };
  # zram
  zramSwap.enable = true;

  networking = {
    hostId = "3f4e9fd8";
    hostName = host;
  };
  services = {
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = lib.mkForce true;
    blueman.enable = true;
    # hardware.bolt.enable = true;

    # # ectool on start up
    # systemd.services.ectool = {
    # 	description = "Run ECTool on start up to swap left alt and left super";
    # 	enable = true;
    # 	path = [ pkgs.fw-ectool ];
    # 	serviceConfig = {
    # 	Type = "simple";
    # 	User = "root";
    # 	Group = "root";
    # 	Restart = "always";
    # 	After = ["suspend.target" "hibernate.target"];
    # 	};
    # 	script = ''
    # 	ectool raw 0x3E0C d1,d1,b1,b3,wE01F
    # 	ectool raw 0x3E0C d1,d1,b3,b1,w11
    # 	'';
    # 	wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" ];
    # };

    # qmk for linux
    keyd = {
      enable = true;
      keyboards.true = {
        ids = [ "*" ];
        settings = {
          main = {
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            capslock = "leftcontrol";

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
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            capslock = "leftcontrol";

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

          "meta+alt" = {
            capslock = "capslock";
          };

          "alt" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };

    transmission.enable = false;
  };

  programs = {
    steam.enable = false;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = lib.mkForce false; # powers up the default Bluetooth controller on boot
  };

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment.systemPackages = with pkgs; [
    lact
    amdgpu_top
  ];

  # Desktop environment
  # Override xdg.portal.wlr.enable, theres conflict
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };
  programs.hyprland = lib.mkIf (host != "vm") {
    enable = true;
    withUWSM = true;
  };

  hm = {
    services.hyprpaper.settings = {
      wallpaper = [
        "eDP-1,${wpPath}"
      ];
    };

    # Hyprland settings
    wayland.windowManager.hyprland.settings = lib.mkIf config.programs.hyprland.enable {
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
        "sleep 3;hyprctl dispatch workspace 8;hyprctl dispatch workspace 9;hyprctl dispatch workspace 10;hyprctl dispatch workspace 1"
      ];
    };
  };
}
