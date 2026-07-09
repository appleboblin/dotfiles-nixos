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

    noctalia-greeter = {
      enable = true;

      # Optional configuration
      greeter-args = "--session Niri --user appleboblin";
    };
  };
}
