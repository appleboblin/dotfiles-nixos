{
  description = "NixOS config flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Desktop environment
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apps
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
            inherit inputs host user;
          };
          modules = [
            ./nixos
            ./overlays
            ./hosts/${host}/configuration.nix
            ./hosts/${host}/hardware.nix

            catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            (nixpkgs.lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs host user;
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
      };
      templates = import ./templates;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
