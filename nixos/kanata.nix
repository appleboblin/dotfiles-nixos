{
  lib,
  ...
}:
{
  services.kanata = {
    enable = lib.mkDefault true;
  };
}
