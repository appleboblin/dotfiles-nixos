{
  host,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

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

  hardware = {
    bluetooth = {
      enable = true;
      # powerOnBoot = lib.mkForce false;
    };
  };

  # AMDGPU Controller
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://github.com/paschoal/dotfiles/blob/master/hardware/radeon/default.nix
  environment.systemPackages = with pkgs; [
    lact
    amdgpu_top
    fw-ectool
    framework-tool
  ];

  # Desktop environment
  # Override xdg.portal.wlr.enable, theres conflict
  xdg.portal = {
    wlr.enable = lib.mkForce false;
  };

  programs = {
    niri.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = lib.mkForce true;
    blueman.enable = true;
    hardware.bolt.enable = true;

    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

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
  };
}
