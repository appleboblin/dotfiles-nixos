{
  config,
  inputs,
  pkgs,
  lib,
  host,
  user,
  ...
}:
{
  imports = [
    ./boot.nix
    ./docker.nix
    ./fonts.nix
    ./games.nix
    ./localsend.nix
    ./noctalia.nix
    ./tailscale.nix
    ./transmission.nix
    ./kanata.nix
    ./zfs.nix
  ];

  # Nix Package Manager
  nix = {
    optimise.automatic = true;
    registry.dots.flake = inputs.self;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "${user}"
        "root"
        "@wheel"
      ];
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

  catppuccin.autoEnable = true;
  # Set your time zone.
  # time.timeZone = "Asia/Taipei";
  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Pacific/Tahiti";
  services = {
    accounts-daemon.enable = true;
    # https://discourse.nixos.org/t/timezones-how-to-setup-on-a-laptop/33853/8
    automatic-timezoned.enable = false; # uses country IP so vpn to other country will change time
    geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    speechd.enable = false;

    # Power handeling
    power-profiles-daemon.enable = true;
    upower.enable = true;

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
            # CH314A USB SPI
            SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="5512", TAG+="uaccess", SYMLINK+="ch341a_spi"
        		'';

      packages = [
        pkgs.yubikey-personalization
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
      services = {
        login = {
          enableGnomeKeyring = true;
          u2fAuth = false;
        };
        # niri.enableGnomeKeyring = true;
        # greetd.enableGnomeKeyring = true;
        # login.enableGnomeKeyring = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware = {
    flipperzero.enable = true;
    # OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  zramSwap.enable = true;

  # gtk themes on qt
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "dialout"
    ];
    openssh.authorizedKeys.keyFiles = [
      ./id_ed25519.pub
    ];
  };

  documentation.doc.enable = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
      ];
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    systemPackages =
      with pkgs;
      [
        neovim
        killall
        wget
        usbutils
        git
        git-lfs
        nvtopPackages.full
        fzf
        wireguard-tools # vpn
        nfs-utils # nfs file share
        cifs-utils
        libimobiledevice
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
        tree
      ]
      ++ lib.optionals config.virtualisation.libvirtd.enable [
        virtiofsd # vm
        spice-gtk
      ];
  };

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    nix-ld.enable = true;
    flashrom.enable = true;
    dconf.enable = true;
    yubikey-touch-detector.enable = true;

    # Thunar
    xfconf.enable = true;
    # file-roller.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };

    virt-manager = {
      enable = config.virtualisation.libvirtd.enable;
    };

    nh = {
      enable = true;
      flake = "/home/${user}/dotfiles-nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 14d --keep 5";
      };
    };
  };

  virtualisation = {
    spiceUSBRedirection.enable = config.virtualisation.libvirtd.enable;

    # QEMU/KVM
    libvirtd = {
      # Don't auto start vm server
      # sudo systemctl start libvertd
      enable = lib.mkDefault false;
    };
  };

  networking = {
    # Enable networking
    networkmanager.enable = true;

    hostName = host;

    firewall = {
      enable = true;
      allowedTCPPorts = lib.optionals config.virtualisation.libvirtd.enable [
        16509 # libvirt
      ];
      allowedTCPPortRanges = lib.optionals config.virtualisation.libvirtd.enable [
        {
          from = 5900;
          to = 5999;
        } # SPICE
      ];
      # if packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      extraCommands = ''
        iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
      '';
    };
  };

  # Don't Delete
  system.stateVersion = "23.11";
}
