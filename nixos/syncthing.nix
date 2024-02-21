{
    config,
    pkgs,
    lib,
    host,
    user,
    ...
}: {
    services.syncthing = {
        enable = true; 
        user = "${user}";
        openDefaultPorts = true;
        dataDir = "/home/${user}/Documents";
        configDir = "/home/${user}/Documents/.config/syncthing";
        overrideDevices = false;     # overrides any devices added or deleted through the WebUI
        overrideFolders = false;     # overrides any folders added or deleted through the WebUI
        settings = {
            gui = {
                user = "${user}";
                password = "password";
            };
            guiAddress = "0.0.0.0:8384";
        };

    };
}