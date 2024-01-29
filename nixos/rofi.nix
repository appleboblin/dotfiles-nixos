{
    config,
    host,
    isLaptop,
    lib,
    pkgs,
    inputs,
    ...
}: {
    # rofi extra
    # users.users.appleboblin = {
    #     packages = with pkgs;[
    #     rofi-calc
    #     ];
    # };
    nixpkgs.overlays = [(final: prev: {
        rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })];
}