{
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  security.polkit.enablePkexecWrapper = true;
  programs = {
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };
  services.displayManager.noctalia-greeter = {
    enable = true;
    greeter-args = "--session Niri --user appleboblin";
  };
}
