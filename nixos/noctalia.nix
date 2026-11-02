{
  inputs,
  user,
  ...
}:
{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  security.polkit.enablePkexecWrapper = true;
  programs = {
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
    umbriel.enable = true;
  };
  services.displayManager.noctalia-greeter = {
    enable = true;
    # greeter-args = "--session Niri --user ${user}";
    greeter-args = "--session Umbriel --user ${user}";
  };

  nix.settings = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };
}
