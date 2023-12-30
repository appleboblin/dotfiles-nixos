{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
                      inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.appleboblin = {
                imports = [ 
                  # common home-manager configuration
                  #./home.nix
                  # host specific home-manager configuration
                  ./hosts/vm/home.nix
                ];

                home = {
                  homeDirectory = "/home/appleboblin";
                };
              };
            };
          }
            ./configuration.nix
            ./hosts/framework/configuration.nix
            ./hosts/framework/hardware-configuration.nix
            # inputs.home-manager.nixosModules.main
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
                      inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.appleboblin = {
                imports = [ 
                  # common home-manager configuration
                  #./home.nix
                  # host specific home-manager configuration
                  ./hosts/vm/home.nix
                ];

                home = {
                  homeDirectory = "/home/appleboblin";
                };
              };
            };
          }
            ./configuration-vm.nix
            ./hosts/vm/configuration.nix
            ./hosts/vm/hardware-configuration.nix
            # inputs.home-manager.nixosModules.vm
          ];
        };
      };
    };
}
