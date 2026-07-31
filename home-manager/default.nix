{
  config,
  pkgs,
  user,
  host,
  lib,
  inputs,
  ...
}:
let
  pkgs-orca = import inputs.nixpkgs-orca { inherit (pkgs) system; };
in
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
        brave
        chromium
        vivaldi
        vivaldi-ffmpeg-codecs
        distrobox
        pavucontrol
        thunderbird
        libreoffice
        vlc
        thunar
        thunar-volman
        thunar-archive-plugin
        file-roller
        ristretto

        # Provides org.gnome.keyring.SystemPrompter
        gcr

        # Other
        vesktop
        filezilla
        inkscape
        remmina
        gimp
        kdePackages.okular
        element-desktop
        v4l-utils
        file
        ffmpeg
        pcloud
        calibre
        libation
        obsidian
        proton-pass
        # grayjay
        freetube
        nix-your-shell
        cryptomator
        proton-vpn
        seahorse
        tinymist
        prettypst
        orca-slicer
        rocmPackages.rocm-smi
        openscad
      ];

    sessionVariables = {
      EDITOR = "zeditor -w";
      BROWSER = "vivaldi";
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
      setSessionVariables = false;
      extraConfig = {
        GITHUB = "${config.home.homeDirectory}/github";
        SCREENSHOT = "${config.home.homeDirectory}/Pictures/Screenshots";
        SHARE = "${config.home.homeDirectory}/Share";
      };
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # github
    git = {
      enable = true;
      signing.format = null;
      includes = [
        {
          # personal
          condition = "gitdir:~/";
          contents.user = {
            email = "github@appleboblin.com";
            name = user;
          };
        }
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
