{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs
  ];

  xdg.desktopEntries = {
    vivaldi-personal = {
      name = "Vivaldi: Personal";
      exec = "vivaldi --profile-directory=Default %U";
      icon = "vivaldi";
    };
    vivaldi-school = {
      name = "Vivaldi: School";
      exec = ''vivaldi --profile-directory="Profile 1" %U'';
      icon = "vivaldi";
    };
  };
}
