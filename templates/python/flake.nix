{
	description = "Python development environment";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
			};

			# Specify Python packages
			pythonPackages = ps: with ps; [
			pip
			flake8
			];

			# Set python version
			python = pkgs.python312.withPackages pythonPackages;

		in
		{
			devShells.default = pkgs.mkShell {
			buildInputs = [
				python
				# Add additional development tools
				pkgs.poetry
				pkgs.black
				pkgs.pylint
			];

			shellHook = ''
				echo "Python development environment ready!"
				echo "Python version: $(python --version)"
			'';
			};
		});
}