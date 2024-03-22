{
  config,
  lib,
  ...
}: {
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = lib.mkDefault "/dev/disk/by-id";

  services.zfs.autoScrub.enable = true;
}
