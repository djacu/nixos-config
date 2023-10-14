{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/nix.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  networking.hostId = "76b05211";
  services.zfs.autoScrub.enable = true;
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = ["zfs"];
  };
}
