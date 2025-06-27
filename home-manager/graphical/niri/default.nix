{
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.config
    ./settings.nix
  ];
}
