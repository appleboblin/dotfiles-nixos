{
  lib,
  ...
}:
{
  programs.localsend = {
    enable = lib.mkDefault true;
    openFirewall = true;
  };
}
