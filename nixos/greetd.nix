{
  config,
  pkgs,
  ...
}:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland = "${config.programs.hyprland.package}/bin/Hyprland";
  # xfce4 = "${pkgs.xfce.xfce4-session}/bin/startxfce4";
in
{
  services.greetd = {
    enable = false;
    settings = {
      # Auto login
      # initial_session = {
      #     command = "${session}";
      #     user = "${user}";
      # };
      default_session = {
        command = "${tuigreet} -g 'Please Login :)' --asterisks --remember --remember-user-session --time --cmd ${hyprland}";
        user = "greeter";
      };
    };
  };
}
