{
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    # inputs.emacs-overlay.overlay
    inputs.niri.overlays.niri
  ];
}
