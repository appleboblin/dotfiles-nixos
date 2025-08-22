{
  config,
  ...
}:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
      };
    };

    # Obs virtual camera
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [
      "v4l2loopback"
    ];
    extraModprobeConfig = ''
      		options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      	'';
  };
}
