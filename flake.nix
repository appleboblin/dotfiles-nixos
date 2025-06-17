{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixvim.url = "github:nix-community/nixvim";
    catppuccin.url = "github:catppuccin/nix";
    hyprpanel.url = "github:jas-singhfsu/hyprpanel";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix/2024.5.939250";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      ...
    }@inputs:
    let
      user = "appleboblin";
      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit inputs host user;
          };
          modules = [
            catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs host user;
                  isLaptop = host == "framework";
                  isVm = host == "vm";
                  isDesktop = host == "desktop";
                };

                users.${user} = {
                  imports = [
                    # common home-manager configuration
                    ./home-manager
                    # host specific home-manager configuration
                    ./hosts/${host}/home.nix
                    # catppuccin
                    catppuccin.homeModules.catppuccin
                  ];
                };
              };
            }
            (nixpkgs.lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "appleboblin" ])
            ./nixos
            ./hosts/${host}/configuration.nix
            ./hosts/${host}/hardware-configuration.nix
            # inputs.home-manager.nixosModules.main
          ];
        };
    in
    {
      nixosConfigurations = {
        framework = mkHost "framework";
        vm = mkHost "vm";
        desktop = mkHost "desktop";
      };
    };
}
