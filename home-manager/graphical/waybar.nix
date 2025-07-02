{
  programs.waybar = {
    systemd.enable = true;
    # settings = {
    # };

    style = ''
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
        background-color: #24273a; /* base */
        color: #cad3f5;            /* text */
        margin-top: 0px;
        border-radius: 0px;
        opacity: 0.95;
      }

      #custom-launcher {
        font-size: 24px;
        padding: 5px;
      }

      button {
        border: none;
        border-radius: 0;
      }

      button:hover {
        background: transparent;
        color: transparent;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #cad3f5; /* text */
      }

      #workspaces button.active {
        color: #24273a; /* base */
        background-color: #f5bde6; /* pink */
      }

      #workspaces button.urgent {
        background-color: #ed8796; /* red */
      }

      #mode {
        background-color: #363a4f; /* surface0 */
      }

      #window,
      #workspaces {
        margin: 0 4px;
      }

      #battery.charging, #battery.plugged {
        color: #a6da95; /* green */
      }

      #battery.warning:not(.charging) {
        color: #eed49f; /* yellow */
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.critical:not(.charging) {
        color: #ed8796; /* red */
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #tray {
        color: #cad3f5; /* text */
        margin-right: 10px;
      }

      #cpu {
        color: #f5a97f; /* peach */
      }

      #memory {
        color: #c6a0f6; /* mauve */
      }

      #network {
        color: #a6da95; /* green */
      }

      #network.disconnected {
        color: #ed8796; /* red */
      }

      #pulseaudio {
        color: #eed49f; /* yellow */
      }

      #wireplumber.muted {
        background-color: #ed8796; /* red */
      }

      #custom-powermenu {
        color: #ed8796; /* red */
        margin-right: 16px;
      }

      #bluetooth.off {
        color: #ed8796; /* red */
        margin-right: 8px;
      }

      #bluetooth.on {
        color: #8aadf4; /* blue */
        margin-right: 8px;
      }

      #custom-wireguard {
        margin-right: 5px;
      }

      #custom-notification {
        font-family: "NotoSansMono Nerd Font";
      }
    '';

  };
}
