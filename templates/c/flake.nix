{
    description = "Rust development environment";

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

        in
        {
            devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
                # library depends
                gmp gmp.dev
                isl
                libffi libffi.dev
                libmpc
                libxcrypt
                mpfr mpfr.dev
                xz xz.dev
                zlib zlib.dev

                # git checkout need flex as they are not complete release tarballs
                m4
                bison
                flex
                texinfo
                
                # test harness
                dejagnu
                autogen
                
                # toolchain itself
                gcc
                stdenv.cc
                stdenv.cc.libc stdenv.cc.libc_dev
            ];

            shellHook = ''
            '';
            };
        });
}