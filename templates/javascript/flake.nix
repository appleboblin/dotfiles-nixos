{
  description = "JavaScript development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core
            nodejs
            yarn

            # Development tools
            nodePackages.prettier
            nodePackages.eslint
            nodePackages.typescript
          ];

          shellHook = ''
            echo "JavaScript development environment ready!"
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo "yarn version: $(yarn --version)"
          '';
        };
      }
    );
}
