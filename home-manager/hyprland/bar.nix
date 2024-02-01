{
    config,
    pkgs,
    lib,
    ...
}: {
    programs.waybar = {
        # settings = {
        # };

        style =
        ''
        * {
        font-family: MesloLGS Nerd Font, FiraCode Nerd Font, sans-serif;
        font-size: 24px;
        min-height: 0;
        border: none;
        border-radius: 0;
        }
        .horizontal {
        padding: 2px;
        }

        window#waybar {
        background-color: #2e3440;
        color: #eceff4;
        margin-top: 0px;
        border-radius: 0px;
        opacity: 0.8;
        }

        #custom-launcher {
        font-size: 24px;
        padding: 5px;
        }

        button {
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
        background: transparent;
        color: transparent;
        }

        #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #eceff4;
        }

        #workspaces button.active {
        background-color: #81a1ca;
        }

        #workspaces button.urgent {
        background-color: #bf616a;
        }

        #mode {
        background-color: #2e3440;
        }

        #window,
        #workspaces {
        margin: 0 4px;
        }

        #battery.charging, #battery.plugged {
        color: #a3be8c;
        }

        #battery.warning:not(.charging) {
        color: #ebcb8b;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        }

        #battery.critical:not(.charging) {
        color: #bf616a;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        }

        #tray {
        color: #eceff4;
        margin-right: 10px;
        }

        #cpu {
        color: #b08770;
        }

        #memory {
        color: #b48ead;
        }

        #network {
        color: #a3be8c;
        }

        #network.disconnected {
        color: #f53c3c;
        }

        #pulseaudio {
        color: #ebcb8b;
        }

        #wireplumber.muted {
        background-color: #f53c3c;
        }

        #custom-powermenu {
        color: #b3616a;
        margin-right: 16px;
        }  
        '';
    };
}
