{
    config,
    pkgs,
    lib,
    ...
}: {
    programs.xxx = {
        enable = true / host != "vm"; # optional
        
        settings = {
        
        };
    };
}
