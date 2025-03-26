{
  config,
  pkgs,
  user,
  host,
  lib,
  ...
}:
{
  imports = [
    ./programs
    ./shell
    ./hyprland
  ];

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = user;
    homeDirectory = "/home/${user}";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages =
      with pkgs;
      lib.mkIf (host != "vm") [
        # browser
        brave
        chromium
        floorp
        vivaldi
        vivaldi-ffmpeg-codecs

        # Programming
        python3

        # Terminal
        # kitty
        # alacritty
        distrobox

        # Window Manager
        pavucontrol
        grimblast
        # xfce.ristretto

        # Daily
        thunderbird
        libreoffice
        vlc
        protonmail-bridge

        # Other
        # webcord
        discord
        vesktop
        betaflight-configurator
        prusa-slicer
        # openscad
        # freecad
        filezilla
        inkscape
        # libtransmission
        # quickemu
        # quickgui
        remmina
        gimp
        kdePackages.okular
        qalculate-gtk
        # protonvpn-gui
        # amdgpu_top
        # rpi-imager
        # sublime4
        # qflipper
        # jetbrains.pycharm-community
        parsec-bin
        # supersonic-wayland
        # freetube
        # direnv
        element-desktop
        prismlauncher
        v4l-utils
        file
        ffmpeg
        yt-dlp
        # mysql-workbench
        r2modman
        nextcloud-client
        gnome-disk-utility
        # rawtherapee
        # digikam
        darktable
        pcloud

        # calibre
        # jflap
        texliveFull
        # httrack
        # hugin
        # evince
        # zed-editor
        # nixd
        obsidian
        # wireshark
        android-udev-rules
        # mongodb-compass
        # kiwix
        moonlight-qt
        # github-desktop
        pdfslicer
        # (assert (lib.assertMsg (obsidian.version != "1.4.16")
        #     "obsidian: has wayland crash been fixed?");
        #     obsidian.override {
        #         electron = electron_24.overrideAttrs (_: {
        #         preFixup =
        #             "patchelf --add-needed ${libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
        #         meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
        #         });
        # })
        # (hyprsunset.overrideAttrs (o: {
        #     src = pkgs.fetchFromGitHub {
        #     owner = "hyprwm";
        #     repo = "hyprsunset";
        #     rev = "v0.1.0";
        #     hash = "sha256-SVkcePzX9PAlWsPSGBaxiNFCouiQmGOezhMo0+zhDIQ=";
        #     };
        # }))
      ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    # file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    # };

    # home.directories = {
    #     extra = [
    #     # {
    #     #     path = "/home/${user}/github";
    #     # }
    #     {
    #         path = "/home/${user}/Pictures/Screenshot";
    #     }
    #     ];
    # };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/appleboblin/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      EDITOR = "zeditor -w";
      BROWSER = "vivaldi";
      TERMINAL = "xterm-256color";
    };
  };

  # default stuff
  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        # desktop files from environment.systemPackages are located in
        # /run/current-system/sw/share/applications/
        # desktof files from home-manager are located in
        # /etc/profiles/per-user/appleboblin/share/applications
        # /nix/store/hash-home-manager-path/share/applications
        # MIME types https://www.sitepoint.com/mime-types-complete-list/
        # "default-web-browser" = [ "floorp.desktop" ];
        # "text/html" = [ "floorp.desktop" ];
        # "x-scheme-handler/http" = [ "floorp.desktop" ];
        # "x-scheme-handler/https" = [ "floorp.desktop" ];
        # "x-scheme-handler/about" = [ "floorp.desktop" ];
        # "x-scheme-handler/unknown" = [ "floorp.desktop" ];
        # browser stuff
        "default-web-browser" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/about" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/unknown" = [ "vivaldi-stable.desktop" ];
        "text/html" = [ "vivaldi-stable.desktop" ];

        # text editor
        "text/plain" = "dev.zed.Zed.desktop";
        "text/css" = "dev.zed.Zed.desktop";
        "text/javascript" = "dev.zed.Zed.desktop";
        "text/markdown" = "dev.zed.Zed.desktop";
        "text/xml" = "dev.zed.Zed.desktop";
        "text/csv" = "dev.zed.Zed.desktop";
        "text/rtf" = "dev.zed.Zed.desktop";
        "text/vtt" = "dev.zed.Zed.desktop";
        "text/x-c" = "dev.zed.Zed.desktop";
        "text/x-c++" = "dev.zed.Zed.desktop";
        "text/x-java" = "dev.zed.Zed.desktop";
        "text/x-python" = "dev.zed.Zed.desktop";
        "text/x-php" = "dev.zed.Zed.desktop";
        "text/x-shellscript" = "dev.zed.Zed.desktop";
        "text/x-sql" = "dev.zed.Zed.desktop";
        "text/x-yaml" = "dev.zed.Zed.desktop";
        "text/x-lua" = "dev.zed.Zed.desktop";
        "text/x-perl" = "dev.zed.Zed.desktop";
        "text/x-ruby" = "dev.zed.Zed.desktop";

        "application/pdf" = [ "okularApplication_pdf.desktop" ];

        "image/jpeg" = [ "org.xfce.ristretto.desktop" ];
        "image/png" = [ "org.xfce.ristretto.desktop" ];

        "x-scheme-handler/magnet" = "transmission.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_GITHUB_DIR = "${config.home.homeDirectory}/github";
        XDG_SCREENSHOT_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
        XDG_SHARE_DIR = "${config.home.homeDirectory}/Share";
      };
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # github
    git = {
      enable = true;
      includes = [
        {
          # personal
          condition = "gitdir:~/";
          contents.user = {
            email = "github@appleboblin.com";
            name = user;
          };
        }
        # { # work
        #     condition = "gitdir:~/Work/";
        #     contents.user = {
        #     email = "work@email.com";
        #     name = "My Name";
        #     };
        # }
      ];
    };
  };

  # KVM
  dconf.settings = lib.mkIf (host != "vm") {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # kde connect
  # services.kdeconnect.enable = true;
}
