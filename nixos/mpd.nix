{
    config,
    pkgs,
    lib,
    host,
    user,
    ...
}: {
    # services.mpd = {
    #     enable = host != "vm";
    #     musicDirectory = "/home/${user}/Music/";
    #     # user = "${user}"; # nixos, not home
    #     dataDir = "/home/${user}/.config/mpd";
    #     extraConfig = ''
    #         audio_output {
    #             type "pulse"
    #             name "Pulseaudio"
    #             server "127.0.0.1" # add this line - MPD must connect to the local sound server
    #         }
    #     '';

    #     # Optional:
    #     network.listenAddress = "any"; # if you want to allow non-localhost connections
    #     network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    # };

    # services.mpd = {
    #     enable = true;
    #     # dataDir = "${config.xdg.dataHome}/mpd";
    #     musicDirectory = "/home/${user}/Music/";
    #     extraConfig = ''     
    #     audio_output {
    #         type    "pipewire"
    #         name    "pipewire"
    #     }
    #     auto_update "yes"
    #     '';
    # };

    services.mpd = {
        enable = host != "vm";
        musicDirectory = "/home/${user}/Music/";
        # playlist_directory = "~/.mpd/playlists";
        # dataDir = "~/.mpd/data";
        extraConfig = ''
            audio_output {
                type "pipewire"
                name "My PipeWire Output"
            }
            bind_to_address "127.0.0.1"
        '';
        user = "${user}";
        # Optional:
        network.listenAddress = "any"; # if you want to allow non-localhost connections
        startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
        };
        systemd.services.mpd.environment = {
        # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
        XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
    };
}
