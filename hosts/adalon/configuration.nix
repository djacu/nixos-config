{
  config,
  pkgs,
  ...
}: {
  networking.hostId = "00000000";
  services.zfs.autoScrub.enable = true;
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = ["zfs"];
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
}
