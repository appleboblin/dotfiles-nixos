{
  lib,
  ...
}:
{
  programs.texlive = {
    enable = lib.mkDefault false;
  };
}
