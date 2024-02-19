# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  user,
  host,
  ...
}: {
  imports = [];

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Nix Package Manager
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # unlock gnome keyring
  # security.pam.services.sddm.enableGnomeKeyring = true;
  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_TW.UTF-8";
    LC_IDENTIFICATION = "zh_TW.UTF-8";
    LC_MEASUREMENT = "zh_TW.UTF-8";
    LC_MONETARY = "zh_TW.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "zh_TW.UTF-8";
    LC_PAPER = "zh_TW.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable the Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.sddm.wayland.enable = true;
  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  #   # theme = "Nordic";
  #   # {
  #   #   package = pkgs.nordic;
  #   #   name = "Nordic";
  #   # };
  # };
  # services.xserver.displayManager = {
  #   defaultSession = "hyprland";
  #   autoLogin = {
  #     enable = false;
  #     user = "appleboblin";
  #   };
  #   lightdm = {
  #     enable = true;
  #     greeters = {
  #       gtk = {
  #         enable = true;
  #         theme = {
  #           package = pkgs.nordic;
  #           name = "Nordic";
  #         };
  #         cursorTheme = {
  #           name = "Nordic";
  #           size = 32;
  #         };
  #         iconTheme.name = "Nordic";
  #         extraConfig = lib.mkDefault ''
  #         font-name = Inter 30
  #         background = ${./nordic_wall.jpg}
  #         '';
  #         # background=${pkgs.nordic}/share/wallpapers/Nordic/nordic-wall.jpg
  #       };
  #     };
  #   };
  #   };

  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.desktopManager.cinnamon.enable = true;

  services.xserver.excludePackages = with pkgs; [ xterm ];

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      # variant = "colemak_dh_ortho";
    };
  };

  # # Get fcitx5 working
  i18n.inputMethod = {
    enabled = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chewing
      ];
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Proton mail and vpn fix
  # services.passSecretService.enable = true;
  services.gnome.gnome-keyring.enable = true;
  systemd.user.services.protonmail-bridge = {          
    description = "Protonmail Bridge";          
    enable = true;          
    script = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive --log-level info";          
    path = [ pkgs.gnome3.gnome-keyring ]; # HACK: https://github.com/ProtonMail/proton-bridge/issues/176          
    wantedBy = [ "graphical-session.target" ];          
    partOf = [ "graphical-session.target" ];
  };
  
  # Enable sound with pipewire.
  sound.enable = true;
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # mpd stuff
  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";

  xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
  # Obs virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [
    "v4l2loopback"
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
  
  # OpenGL
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.appleboblin = {
    isNormalUser = true;
    description = "appleboblin";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    # shell = pkgs.zsh;
    packages = with pkgs; lib.mkIf ( host != "vm" )[
      # mpd
      mpc_cli
    ];
  };
  # programs.nm-applet.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-24.8.0"
  ];
  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nano
    micro
    neovim
    killall
    wget
    curl
    gzip
    git
    htop
    btop
    eza
    fzf
    neofetch
    procps
    bash-completion
    # xwaylandvideobridge
    # nordic
  ];

  # Thunar
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # allow /bin and /usr/bin shebangs to work
  services.envfs.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # QEMU/KVM
  virtualisation.libvirtd = {
    enable = host != "vm";
  };
  programs.virt-manager = {
    enable = host != "vm";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
