{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        # nixpkgs.url = "github:nixos/nixpkgs/23.11";
        nixpkgs_22_11.url = "github:nixos/nixpkgs/nixos-22.11";
        spicetify-nix.url = "github:the-argus/spicetify-nix";
        # nur.url = "github:nix-community/NUR";
        nixos-hardware.url = "github:NixOS/nixos-hardware";
        nixvim = {
        url = "github:nix-community/nixvim";
        # inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
        url = "github:nix-community/home-manager";
        # url = "github:nix-community/home-manager/release-23.11";
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
                    ];
                };
                };
            }
            (nixpkgs.lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "appleboblin"])
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
        desktop = mkHost "desktop";
        };
    };
}
