{
  description = "NixOS config flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixvim.url = "github:nix-community/nixvim";
    hyprpanel.url = "github:jas-singhfsu/hyprpanel";
    niri.url = "github:sodiboo/niri-flake";

    # Python tool
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
            isLaptop = host == "framework";
            isVm = host == "vm";
            isDesktop = host == "desktop";
          };

          modules = [
            ./nixos
            ./modules
            ./hosts/${host}/configuration.nix
            ./hosts/${host}/hardware-configuration.nix

            catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            (nixpkgs.lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit
                    inputs
                    host
                    user
                    ;
                  isLaptop = host == "framework";
                  isVm = host == "vm";
                  isDesktop = host == "desktop";
                };

                users.${user} = {
                  imports = [
                    ./home-manager
                    ./hosts/${host}/home.nix
                    catppuccin.homeModules.catppuccin
                  ];
                };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        framework = mkHost "framework";
        desktop = mkHost "desktop";
        vm = mkHost "vm";
      };
    };
}
