{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  home.packages = with pkgs; [
    ddcutil
  ];
  programs.noctalia = {
    enable = true;
  };
}
