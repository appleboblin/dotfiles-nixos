{
  config,
  pkgs,
  lib,
  host,
  ...
}:
{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./localsend.nix
    ./steam.nix
    ./syncthing.nix
    ./tailscale.nix
    ./transmission.nix
  ];

  # Nix Package Manager
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "appleboblin"
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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

    # # Get fcitx5 working
    inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-chewing
        ];
      };
    };
  };

  # Set your time zone.
  # time.timeZone = "Asia/Taipei";Pacific/Tahiti.
  # time.timeZone = "Pacific/Tahiti";
  services = {
    # https://discourse.nixos.org/t/timezones-how-to-setup-on-a-laptop/33853/8
    automatic-timezoned.enable = true;
    geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      autorun = true;

      desktopManager.xfce.enable = true;

      xkb = {
        layout = "us";
      };
    };

    displayManager.gdm = {
      enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    gnome.gnome-keyring.enable = true;
    protonmail-bridge = lib.mkIf (host == "desktop") {
      enable = true;
      package = pkgs.protonmail-bridge;
      logLevel = "info";
      path = [ pkgs.gnome-keyring ]; # HACK: https://github.com/ProtonMail/proton-bridge/issues/176
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;

    };
    # Flatpak
    flatpak.enable = true;

    # security key
    yubikey-agent.enable = true;

    # iPhone mount
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    # services.gvfs.enable = true; # Mount, trash, and other functionalities
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };
    tumbler.enable = true; # Thumbnail support for images

    # List services that you want to enable:
    # allow /bin and /usr/bin shebangs to work
    envfs.enable = true;
    udev = {
      # Udev rules
      extraRules = ''
        		SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
        		# pixel 8
        		SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee2", MODE="0660", GROUP="plugdev", SYMLINK+="android%n"
        		SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee7", MODE="0660", GROUP="plugdev", SYMLINK+="android%n"
        		SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4eec", MODE="0660", GROUP="plugdev", SYMLINK+="android%n"
        		SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee0", MODE="0660", GROUP="plugdev", SYMLINK+="android%n"
        		'';

      packages = [
        pkgs.yubikey-personalization
        (pkgs.writeTextFile {
          name = "qflipper_udev";
          text = ''
            			#Flipper Zero serial port
            			SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
            			#Flipper Zero DFU
            			SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
            			#Flipper ESP32s2 BlackMagic
            			SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
            			'';
          destination = "/etc/udev/rules.d/42-flipperzero.rules";
        })
        (pkgs.writeTextFile {
          name = "solo2_udev";
          text = ''
            			# NXP LPC55 ROM bootloader (unmodified)
            			SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0021", TAG+="uaccess"
            			# NXP LPC55 ROM bootloader (with Solo 2 VID:PID)
            			SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b000", TAG+="uaccess"
            			# Solo 2
            			SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
            			# Solo 2
            			SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
            			'';
          destination = "/etc/udev/rules.d/70-solo2.rules";
        })
      ];
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    # fstrim
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      u2f.enable = true;
      services.hyprlock = {
        text = "auth include login";
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # gtk themes on qt
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.appleboblin = {
    isNormalUser = true;
    description = "appleboblin";
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    openssh.authorizedKeys.keyFiles = [
      ./id_ed25519.pub
    ];
  };

  nixpkgs = {
    config = {
      # https://nixos.org/manual/nixos/stable/index.html#module-services-flatpak
      # programs.nm-applet.enable = true;
      allowUnfree = true;
      permittedInsecurePackages = [
      ];
    };
  };

  environment = {
    variables = {
      EDITOR = "zeditor -w";
      BROWSER = "vivaldi";
      TERMINAL = "xterm-256color";
      DISPLAY = ":0 {if QT} QT_QPA_PLATFORM=xcb application";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    systemPackages = with pkgs; [
      nano
      micro
      neovim
      killall
      wget
      usbutils
      curl
      gzip
      git
      git-lfs
      htop
      btop
      nvtopPackages.full
      eza
      fzf
      neofetch
      fastfetch
      procps
      bash-completion
      virtiofsd # vm
      spice-gtk
      wireguard-tools # vpn
      nfs-utils # nfs file share
      cifs-utils
      openmpi
      ior
      lxqt.lxqt-policykit
      libimobiledevice
      ifuse # optional, to mount using 'ifuse'
      libheif
      ffmpeg
      imagemagick
      zip
      rar
      unzip
      p7zip
      rsync
      ntfs3g
      yubioath-flutter
      solo2-cli
      mlocate
      tree
    ];
  };

  programs = {
    dconf.enable = true;
    yubikey-touch-detector.enable = true;

    # Thunar
    xfconf.enable = true;
    file-roller.enable = true;
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];

    virt-manager = {
      enable = host != "vm";
    };
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;

    # QEMU/KVM
    libvirtd = {
      enable = host != "vm";
      qemu.ovmf.enable = host != "vm";
    };
  };

  networking = {
    # Enable networking
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 5900;
          to = 5999;
        } # spice
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedTCPPorts = [
        16509 # libvirt
      ];
      # if packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      # wireguard trips rpfilter up
      extraCommands = ''
        			ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        			ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
        			iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
        		'';
      extraStopCommands = ''
        			ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        			ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
        		'';
    };
    # wireguard
    wireguard.enable = true;
  };

  # Don't Delete
  system.stateVersion = "23.11";
}
