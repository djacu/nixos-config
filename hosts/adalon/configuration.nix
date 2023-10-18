{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/nix.nix
  ];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = ["zfs"];
  };

  environment.systemPackages = with pkgs; [
    alejandra
    vim
    wget
  ];

  networking.hostId = "76b05211";
  networking.hostName = "adalon";

  services.openssh.enable = true;

  services.zfs.autoScrub.enable = true;

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "23.11";
}
