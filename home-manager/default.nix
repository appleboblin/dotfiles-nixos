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
    ./graphical
    ./programs
    ./shell
    ./themes
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";

    # Don't Delete!
    stateVersion = "23.11";

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
        distrobox

        # Window Manager
        pavucontrol
        grimblast

        # Daily
        thunderbird
        libreoffice
        vlc

        # Other
        discord
        vesktop
        betaflight-configurator
        prusa-slicer
        filezilla
        inkscape
        remmina
        gimp
        kdePackages.okular
        qalculate-gtk
        parsec-bin
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
        # darktable
        pcloud
        calibre
        libation
        obsidian
        android-udev-rules
        moonlight-qt
        pdfslicer
        direnv
        proton-pass
        grayjay
        freetube
        nix-your-shell
        cryptomator
      ];

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

    sessionVariables = {
      EDITOR = "zeditor -w";
      BROWSER = "vivaldi";
      TERMINAL = "xterm-256color";
      DISPLAY = ":0 {if QT} QT_QPA_PLATFORM=xcb application";
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
}
