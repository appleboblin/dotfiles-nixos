{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; lib.mkForce [
    vscodium
  ];
}
