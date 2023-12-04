{
  pkgs,
  pw-volume,
  ...
}: {
  home.packages = [
    pkgs.pulseaudio
    pw-volume
  ];
}
