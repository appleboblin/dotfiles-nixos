{
    config,
    pkgs,
    user,
    host,
    lib,
    inputs,
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
    # home.sessionVariables.BROWSER = "${lib.getExe pkgs.firefox}";
    # xdg.mimeApps = {
    #     enable = true;
    #     defaultApplications = {
    #         # "application/xhtml+xml" = "${lib.getExe pkgs.firefox}/share/applications/firefox.desktop";
    #         # "text/html" = "${lib.getExe pkgs.firefox}/share/applications/firefox.desktop";
    #         # "text/xml" = "${lib.getExe pkgs.firefox}/share/applications/firefox.desktop";
    #         # "x-scheme-handler/ftp" = "${lib.getExe pkgs.firefox}/share/applications/firefox.desktop";
    #         # "x-scheme-handler/http" = "${lib.getExe pkgs.firefox}/share/applications/firefox.desktop";
    #         # "x-scheme-handler/https" = "${lib.getExe pkgs.firefox}/share/applications/firefox.desktop";
    #         "application/xhtml+xml" = "firefox.desktop";
    #         "text/html" = "firefox.desktop";
    #         "text/xml" = "firefox.desktop";
    #         "x-scheme-handler/ftp" = "firefox.desktop";
    #         "x-scheme-handler/http" = "firefox.desktop";
    #         "x-scheme-handler/https" = "firefox.desktop";
    #     };
    # };

    xdg.mimeApps = {
        enable                              =  true;
        defaultApplications = {
            "default-web-browser"           = [ "firefox.desktop" ];
            "text/html"                     = [ "firefox.desktop" ];
            "x-scheme-handler/http"         = [ "firefox.desktop" ];
            "x-scheme-handler/https"        = [ "firefox.desktop" ];
            "x-scheme-handler/about"        = [ "firefox.desktop" ];
            "x-scheme-handler/unknown"      = [ "firefox.desktop" ];
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
    # home.packages = with pkgs; lib.mkIf (host != "vm") [

    home.packages = with pkgs; [
        # Browser
        # firefox
        # librewolf
        brave
        chromium

        # Programming
        # vscodium
        python3

        # Terminal
        # kitty
        alacritty
        rar

        # Window Manager
        rofi
        bluez
        pavucontrol

        # Daily
        thunderbird
        protonmail-bridge
        protonvpn-gui
        obsidian
        libreoffice
        vlc
        ncspot
        pcloud
        obsidian

        # Other
        webcord
        betaflight-configurator
        prusa-slicer
        openscad
        freecad
        filezilla
        inkscape
        libtransmission
        # quickemu
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
    #     {
    #         path = "/home/${user}/github";
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
        EDITOR = "${lib.getExe pkgs.neovim}";
        BROWSER = "${lib.getExe pkgs.firefox}";
        TERMINAL = "${lib.getExe pkgs.kitty}";
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
            email = "appleboblin@proton.me";
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
    # networkmanager remember password
    # services.gnome-keyring.enable = true;
}