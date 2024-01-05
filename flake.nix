{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    user = "appleboblin";
    mkHost = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs host user;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {
                inherit inputs host user;
              };

              users.${user} = {
                imports = [
                  # common home-manager configuration
                  ./home-manager
                  # host specific home-manager configuration
                  ./hosts/${host}/home.nix
                ];
              };
            };
          }
          ./nixos
          ./hosts/${host}/configuration.nix
          ./hosts/${host}/hardware-configuration.nix
          # inputs.home-manager.nixosModules.main
        ];
      };
  in {
    nixosConfigurations = {
      framework = mkHost "framework";
      vm = mkHost "vm";
    };
  };
}
