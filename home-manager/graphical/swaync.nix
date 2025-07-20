{
  pkgs,
  lib,
  ...
}:
{
  services.swaync = {
    settings = {
      "positionX" = "right";
      "positionY" = "top";
      "control-center-margin-top" = 10;
      "control-center-margin-bottom" = 0;
      "control-center-margin-right" = 10;
      "control-center-margin-left" = 0;
      "notification-icon-size" = 64;
      "notification-body-image-height" = 100;
      "notification-body-image-width" = 200;
      "timeout" = 10;
      "timeout-low" = 5;
      "timeout-critical" = 0;
      "fit-to-screen" = false;
      "control-center-width" = 500;
      "control-center-height" = 1000;
      "notification-window-width" = 500;
      "keyboard-shortcuts" = true;
      "image-visibility" = "when-available";
      "transition-time" = 200;
      "hide-on-clear" = false;
      "hide-on-action" = true;
      "script-fail-notify" = true;
      "notification-visibility" = {
        "spotify" = {
          "state" = "transient";
          "urgency" = "Low";
          "app-name" = "Spotify";
        };
      };
      "widgets" = [
        # "menubar#label"
        # "buttons-grid"
        # "backlight"
        # "backlight#KB"
        "dnd"
        "buttons-grid"
        "mpris"
        "volume"
        "title"
        "notifications"
      ];
      "widget-config" = {
        "title" = {
          "text" = "Notification Center";
          "clear-all-button" = true;
          "button-text" = "󰆴 Clear";
        };
        "volume" = {
          "label" = "󰕾";
          "show-per-app" = true;
        };
        "label" = {
          "max-lines" = 1;
          "text" = "Notification Center";
        };
        "dnd" = {
          "text" = "Do Not Disturb";
        };
        "mpris" = {
          "image-size" = 50;
          "image-radius" = 5;
        };
        "buttons-grid" = {
          "actions" = [
            {
              "label" = "󰐥";
              "command" = "systemctl poweroff";
            }
            {
              "label" = "󰜉";
              "command" = "systemctl reboot";
            }
            {
              "label" = "󰌾";
              "command" = "loginctl lock-session";
            }
            {
              "label" = "󰍃";
              "command" = "loginctl kill-user '$(whoami)'";
            }
            {
              "label" = "󰒲";
              "command" = "systemctl suspend";
            }
            {
              "label" = "󰕾";
              "command" = "${lib.getExe pkgs.pamixer} -t";
            }
            {
              "label" = "󰖩";
              "command" = "rofi-wifi-menu";
            }
            {
              "label" = "󰂯";
              "command" = "blueman-manager";
            }
            {
              "label" = "";
              "command" = "footclient";
            }
          ];
        };
      };
    };

    style = ''
      /* Catppuccin Macchiato Palette */
      @define-color noti-border-color #8aadf4;       /* Blue */
      @define-color noti-bg #363a4f;                 /* Surface0 */
      @define-color noti-bg-alt #24273a;             /* Base */
      @define-color noti-fg #cad3f5;                 /* Text */
      @define-color noti-bg-hover #8aadf4;           /* Blue (hover) */
      @define-color noti-bg-focus #a6da95;           /* Green (focus) */
      @define-color noti-close-bg rgba(202, 211, 245, 0.05); /* Subtle text color */
      @define-color noti-close-bg-hover rgba(202, 211, 245, 0.1);
      @define-color noti-urgent #ed8796;             /* Red */
      @define-color bg-selected #8bd5ca;             /* Teal */

      * {
        color: @noti-fg;
        font-family: "Inter Regular", "Fira Sans", sans-serif;
      }

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: @noti-bg-focus;
        color: @noti-bg-alt;
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3),
                    0 1px 3px 1px rgba(0, 0, 0, 0.7),
                    0 2px 6px 2px rgba(0, 0, 0, 0.3);
        padding: 0;
        background: @noti-bg;
      }

      .critical {
        background: @noti-urgent;
        padding: 2px;
        border-radius: 12px;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 12px;
      }

      .close-button {
        background: @noti-close-bg;
        color: @noti-fg;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        background: @noti-close-bg-hover;
        transition: all 0.15s ease-in-out;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        color: @noti-fg;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
      }

      .notification-default-action {
        border-radius: 12px;
      }

      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
      }

      .notification-action {
        border-radius: 0;
        border-top: none;
        border-right: none;
      }

      .notification-action:first-child {
        border-bottom-left-radius: 10px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        border-right: 1px solid @noti-border-color;
      }

      .body-image {
        margin-top: 6px;
        background-color: #c6a0f6; /* Lavender */
        border-radius: 12px;
      }

      .summary,
      .time,
      .body,
      .top-action-title {
        background: transparent;
        color: @noti-fg;
        text-shadow: none;
      }

      .summary,
      .time {
        font-size: 16px;
        font-weight: bold;
      }

      .body {
        font-size: 15px;
      }

      .control-center {
        background-color: @noti-bg-alt;
      }

      .control-center-list,
      .floating-notifications,
      .blank-window {
        background: transparent;
      }

      /*** Widgets ***/

      .widget-title {
        margin: 8px;
        font-size: 1.5rem;
      }

      .widget-title > button {
        color: @noti-fg;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        border-radius: 12px;
      }

      .widget-title > button:hover {
        background: @noti-bg-hover;
      }

      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
      }

      .widget-dnd > switch {
        border-radius: 12px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
      }

      .widget-dnd > switch:checked {
        background: @bg-selected;
      }

      .widget-dnd > switch slider {
        background: @noti-bg-hover;
        border-radius: 12px;
      }

      .widget-label {
        margin: 8px;
      }

      .widget-label > label {
        font-size: 1.1rem;
      }

      .widget-mpris-player {
        padding: 8px;
        margin: 8px;
      }

      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }

      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      .widget-volume,
      .widget-backlight {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .KB {
        padding: 4px 8px;
        margin: 0 8px;
        border-radius: 0;
      }

      .power-buttons {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .power-buttons > button,
      .powermode-buttons > button,
      .topbar-buttons > button,
      .widget-menubar > box > .menu-button-bar > button {
        background: transparent;
        border: none;
      }

      .power-buttons > button:hover,
      .powermode-buttons > button:hover {
        background: @noti-bg-hover;
      }

      .widget-buttons-grid {
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
        background-color: @noti-bg;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        background: @noti-bg;
        border-radius: 12px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background: @noti-bg-hover;
      }

      .powermode-buttons {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }
    '';

  };
}
