{
  pkgs,
  host,
  ...
}:
{
  programs.mpv = {
    enable = host != "vm"; # optional
    scripts = with pkgs; [
      mpvScripts.uosc
      mpvScripts.sponsorblock
    ];
  };
}
