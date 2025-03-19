{
  pkgs,
  ...
}:
{
  config = {
    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      khelpcenter
      konsole
      oxygen
    ];

    # qt = {
    #     enable = true;
    #     platformTheme = "qt5ct";
    #     style = {
    #         name = "Nordic";
    #         package = pkgs.nordic;
    #     };
    # };
    # gtk = {
    #     enable = true;
    #     theme = {
    #         name = "Nordic";
    #         package = pkgs.nordic;
    #     };
    # };
    # programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      nordic
    ];
  };
}
