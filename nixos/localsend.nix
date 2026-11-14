{
  lib,
  pkgs,
  ...
}:
{
  programs.localsend = {
    enable = lib.mkDefault true;
    openFirewall = true;
    # TODO: remove once nixpkgs localsend's RPATH includes zlib
    package = pkgs.symlinkJoin {
      name = "localsend-zlib-fix";
      paths = [ pkgs.localsend ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for b in $out/bin/*; do
          wrapProgram "$b" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.zlib ]}
        done
      '';
    };
  };
}
