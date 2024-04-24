{
    config,
    pkgs,
    lib,
    host,
    isLaptop,
    isVm,
    inputs,
    osConfig,
    ...
}: {
    imports =  [
        ./keybinds.nix
        ./windowrule.nix
        ./bar.nix
        ./lock.nix
        ./swayidle.nix
    ];
    
    # home = lib.mkIf wayland.windowManager.hyprland.enable {
    #     XCURSOR_SIZE = "24";
    #     HYPR_LOG = "/tmp/hypr/$(command ls -t /tmp/hypr/ | grep -v lock | head -n 1)/hyprland.log";
    # };

    # shellAliases = lib.mkIf wayland.windowManager.hyprland.enable{
    #     hypr-log = "less /tmp/hypr/$(command ls -t /tmp/hypr/ | grep -v lock | head -n 1)/hyprland.log";
    # };
    # lib.mkIf config.wayland.windowManager.hyprland.enable 
    # lib.mkIf osConfig.programs.hyprland.enable 
    config = {
        home = {
            packages = with pkgs; [
                # clipboard history
                cliphist
                wl-clipboard
            ];
        };


        xdg.portal = {
            enable = true;
            # wlr.enable = true;
            extraPortals = [
                pkgs.xdg-desktop-portal-gtk
            ];
            configPackages = [
                pkgs.xdg-desktop-portal-hyprland
            ];
        };

        wayland.windowManager.hyprland = {
            package = pkgs.hyprland;
            settings = {
                env = [
                    "XCURSOR_SIZE,24"
                    "NIXOS_OZONE_WL,1"
                    "WLR_NO_HARDWARE_CURSORS,1"
                    "MOZ_ENABLE_WAYLAND,1"
                    "SDL_VIDEODRIVER,wayland"
                    "CLUTTER_BACKEND,wayland"
                    "XDG_CURRENT_DESKTOP,Hyprland"
                    "XDG_SESSION_DESKTOP,Hyprland"
                    "XDG_SESSION_TYPE,wayland"
                    "GTK_USE_PORTAL,1"
                    "NIXOS_XDG_OPEN_USE_PORTAL,1"
                ];

                input = {
                    kb_layout = "us";
                    # kb_variant = "colemak_dh_ortho";
                    follow_mouse = 1;
                    natural_scroll = true;

                    numlock_by_default = true;
                    sensitivity = 0;

                    touchpad = {
                        natural_scroll = true;
                        disable_while_typing = true;
                        scroll_factor = 0.7;
                    };
                };

                "$mod" =
                    if isVm
                    then "ALT"
                    else "SUPER";

                gestures = lib.mkIf isLaptop {
                    # See https://wiki.hyprland.org/Configuring/Variables/ for more
                    workspace_swipe = true;
                    workspace_swipe_fingers = 4;
                };

                misc = {
                    mouse_move_enables_dpms = true;
                    key_press_enables_dpms = true;
                    disable_hyprland_logo = true;
                };

                general = {
                    gaps_in = 2;
                    gaps_out = 0;
                    border_size = 2;
                    "col.active_border" = "rgba(81a1c1ee) rgba(88c0d0ee) 45deg";
                    "col.inactive_border" = "rgba(3b4252aa)";
                    layout = "master";
                };

                decoration = {
                    # See https://wiki.hyprland.org/Configuring/Variables/ for more
                    blur = {
                        enabled = true;
                        size = 5 ;
                        passes = 1 ;
                        new_optimizations = true;
                    };
                    rounding = 0;
                    drop_shadow = true;
                    shadow_range = 4;
                    shadow_render_power = 3;
                    "col.shadow" = "rgba(1a1a1aee)";
                };

                animations = {
                    enabled = true;
                    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
                    bezier = [
                        "myBezier, 0.05, 0.9, 0.1, 1.05"
                    ];
                    animation = [
                        "windows, 1, 7, myBezier"
                        "windowsOut, 1, 7, default, popin 80%"
                        "border, 1, 10, default"
                        "borderangle, 1, 8, default"
                        "fade, 1, 7, default"
                        "workspaces, 1, 6, default"
                    ];
                };

                dwindle = {
                    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
                    pseudotile = false; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
                    preserve_split = true; # you probably want this
                    smart_split = false;
                };

                master = {
                    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
                    new_is_master = true;
                    orientation = "left";
                    new_on_top = false;
                };

                exec-once = [
                    # clipboard manager
                    "wl-paste --type text --watch cliphist store --max-len 50"
                    "wl-paste --type image --watch cliphist store --max-len 10"
                    # "ectool raw 0x3E0C d1,d1,b1,b3,wE01F & ectool raw 0x3E0C d1,d1,b3,b1,w11"
                    # "nm-applet --indicator"

                    # Desktop dependency
                    "foot --server"
                    "sleep 5;footclient -a scratch"
                    "hyprpaper & waybar & fcitx5 -d"
                    "flatpak run dev.vencord.Vesktop & spotify & obsidian & pcloud & thunderbird"
                    # kitty ncspot kitty --class scratchpad
                    # "${lib.getExe pkgs.swayidle} -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 1200 'systemctl suspend'"
                    # Default browser fix
                    "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
                ];
            };
        };
    };
}