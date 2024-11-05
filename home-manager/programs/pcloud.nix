{
    inputs,
    lib,
    pkgs,
    ...
}:
# https://git.sr.ht/~r-vdp/nixos-config/tree/00076882a59b0ba2feb4d43b95a7a298ebb8bcd2/item/package-overrides.nix#L37
let

    pkgs_22_11 = (import inputs.nixpkgs_22_11 {
        inherit (pkgs) system;
        config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) (map lib.getName [
            pkgs_22_11.pcloud
            ]);
    });
    # https://github.com/NixOS/nixpkgs/issues/226339
    pcloud = pkgs_22_11.pcloud.overrideAttrs (prev:
    let
        version = "1.13.0";
        code = "XZecm6VZIz4VKYBrUbzzhcfNW9boSfrfhgaV";
        # Archive link's codes: https://www.pcloud.com/release-notes/linux.html
        src = pkgs.fetchzip {
        url = "https://api.pcloud.com/getpubzip?code=${code}&filename=${prev.pname}-${version}.zip";
        hash = "sha256-eJpwoVCI96Yow7WfVs3rRwC4D1kh7x7HuMFU7YEFHCM=";
        };

        appimageContents = pkgs.appimageTools.extractType2 {
        name = "${prev.pname}-${version}";
        src = "${src}/pcloud";
        };
    in
    {
        inherit version;
        src = appimageContents;
    });
in {
    home.packages = [ pcloud ];
}
