{
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (final: prev: {
      libdisplay-info_0_2 = prev.libdisplay-info_0_3.overrideAttrs (old: {
        version = "0.2.0";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "emersion";
          repo = "libdisplay-info";
          tag = "0.2.0";
          hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
        };
      });
    })
  ];
}
