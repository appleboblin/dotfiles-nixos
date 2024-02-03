{
    config,
    pkgs,
    lib,
    ...
}: {
    services.dunst = {
        settings = {
            global = {
                # Display
                monitor = 0;
                follow = "none";

                # Geometry
                width = 450;
                height = 300;
                origin = "top-right";
                # geometry = "450x5-0+0";
                offset = "0x0";
                # scale = 0;
                notification_limit = 5;

                # Progress bar
                progress_bar = true;
                progress_bar_height = 10;
                progress_bar_frame_width = 1;
                progress_bar_min_width = 150;
                progress_bar_max_width = 300;

                indicate_hidden = true;
                transparency = 0;
                separator_height = 0;
                padding = 8;
                horizontal_padding = 8;
                text_icon_padding = 0;
                frame_width = 3;

                frame_color = "#81A1C1FF";
                gap_size = 0;
                separator_color = "frame";
                sort = true;

                # Text
                font = "MesloLGS Nerd Font 12";
                line_height = 0;
                markup = "full";
                format = "<b>%s</b>\n%b";
                alignment = "left";
                vertical_alignment = "center";
                show_age_threshold = 60;
                ellipsize = "middle";
                ignore_newline = false;
                stack_duplicates = true;
                hide_duplicate_count = false;
                show_indicators = true;

                # Icons
                enable_recursive_icon_lookup = true;
                icon_theme = "Nordic-darker";
                icon_position = "left";
                min_icon_size = 32;
                max_icon_size = 128;

                # History
                sticky_history = true;
                history_length = 20;

                # Misc/Advanced
                always_run_script = true;
                title = "Dunst";
                class = "Dunst";
                corner_radius = 0;
                ignore_dbusclose = false;

                # Wayland
                layer = "top";
                force_xwayland = false;

                # Legacy
                force_xinerama = false;

                # Mouse
                mouse_left_click = "close_current";
                mouse_middle_click = "do_action, close_current";
                mouse_right_click = "close_all";
            };

            experimental = {
                per_monitor_dpi = false;
            };

            urgency_low = {
                background = "#2E3440FF";
                foreground = "#E5E0F0FF";
                timeout = 10;
            };

            urgency_normal = {
                background = "#2E3440FF";
                foreground = "#E5E0F0FF";
                timeout = 10;
            };

            urgency_critical = {
                background = "#2F3440##";
                foreground = "#E5E0F0FF";
                frame_color = "#BF616AFF";
                timeout = 0;
            };
        };
    };
}
