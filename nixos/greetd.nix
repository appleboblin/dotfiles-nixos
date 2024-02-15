{
    config,
    pkgs,
    lib,
    host,
    user,
    ...
}: let
    tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    session = "${config.programs.hyprland.package}/bin/Hyprland";
in {
    services.greetd = {
        enable = true;
        settings = {
        # Auto login
        # initial_session = {
        #     command = "${session}";
        #     user = "${user}";
        # };
        default_session = {
            command = "${tuigreet} -g 'Please Login :)' --asterisks --remember --remember-user-session --time --cmd ${session}";
            user = "${user}";
        };
        };
    };
}