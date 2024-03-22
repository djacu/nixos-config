{...}: {
  imports = [
    ../common
    ./boot.nix
    ./disko-config.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    ./zfs.nix
    ./zfs-rollback.nix
  ];

  networking.hostId = "76b05211";
  networking.hostName = "adalon";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "23.11";
}
