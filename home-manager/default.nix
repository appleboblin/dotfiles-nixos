{
    config,
    pkgs,
    user,
    host,
    lib,
    ...
}: {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = user;
    home.homeDirectory = "/home/${user}";

    imports = [
        ./programs
        ./shell
        ./hyprland
    ];

    # default stuff
    xdg = {
        configFile."mimeapps.list".force = true;
        mimeApps = {
            enable                              = true;
            defaultApplications = {
                # desktop files from environment.systemPackages are located in
                # /run/current-system/sw/share/applications/
                # desktof files from home-manager are located in
                # /nix/store/hash-home-manager-path/share/applications
                # MIME types https://www.sitepoint.com/mime-types-complete-list/
                "default-web-browser"           = [ "floorp.desktop" ];
                "text/html"                     = [ "floorp.desktop" ];
                "x-scheme-handler/http"         = [ "floorp.desktop" ];
                "x-scheme-handler/https"        = [ "floorp.desktop" ];
                "x-scheme-handler/about"        = [ "floorp.desktop" ];
                "x-scheme-handler/unknown"      = [ "floorp.desktop" ];

                "application/pdf" = [ "okularApplication_pdf.desktop" ];

                "image/jpeg" = [ "org.xfce.ristretto.desktop" ];
                "image/png" = [ "org.xfce.ristretto.desktop" ];
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


    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; lib.mkIf (host != "vm") [
        # Browser
        brave
        chromium
        floorp

        # Programming
        python3

        # Terminal
        # kitty
        alacritty
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
        webcord
        discord
        vesktop
        betaflight-configurator
        prusa-slicer
        openscad
        freecad
        filezilla
        inkscape
        # libtransmission
        # quickemu
        # quickgui
        remmina
        gimp
        okular
        qalculate-gtk
        # protonvpn-gui
        amdgpu_top
        rpi-imager
        sublime4
        qflipper
        jetbrains.pycharm-community
        parsec-bin
        supersonic-wayland
        freetube
        direnv
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
		rawtherapee
		digikam
		darktable

		# calibre
		jflap
		texliveFull
		httrack
		hugin
        evince
        zed-editor
        nixd
        obsidian
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
    home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };

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
    home.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "floorp";
        TERMINAL = "footclient";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # KVM
    dconf.settings = lib.mkIf (host != "vm") {
        "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
        };
    };

    # git
    # programs.git.userEmail = "appleboblin@proton.me";
    # programs.git.userName = user;
    programs.git = {
        enable = true;
        includes = [
        { # personal
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

	# kde connect
	# services.kdeconnect.enable = true;
}
