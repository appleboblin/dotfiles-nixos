{
  description = "NixOS config flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop environment
    catppuccin.url = "github:catppuccin/nix";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    umbriel.url = "github:noctalia-dev/umbriel/cachix";

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
      # dir: which hosts/<dir> to load, when several hosts share one
      mkHost =
        {
          host,
          dir ? host,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs host user;
          };
          modules = [
            ./nixos
            ./overlays
            ./hosts/${dir}/configuration.nix
            ./hosts/${dir}/hardware.nix

            catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            (nixpkgs.lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";

                extraSpecialArgs = {
                  inherit inputs host user;
                };

                users.${user} = {
                  imports = [
                    ./home-manager
                    ./hosts/${dir}/home.nix
                    catppuccin.homeModules.catppuccin
                  ];
                };
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        framework = mkHost {
          host = "framework";
          extraModules = [ ./hosts/framework/amd.nix ];
        };
        framework-intel = mkHost {
          host = "framework-intel";
          dir = "framework";
          extraModules = [ ./hosts/framework/intel.nix ];
        };
        desktop = mkHost { host = "desktop"; };
      };
      templates = import ./templates;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
