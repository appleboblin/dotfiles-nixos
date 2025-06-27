{
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
    # ./settings.nix # importing settings here works but want to separate nix modles and hm
  ];

  programs.niri.enable = true;
}
