{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/nix.nix
    ./disko-config.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = lib.mkDefault "/dev/disk/by-id";

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/unsafe/root@empty
  '';

  environment.systemPackages = with pkgs; [
    alejandra
    vim
    wget
  ];

  networking.hostId = "76b05211";
  networking.hostName = "adalon";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  services.zfs.autoScrub.enable = true;

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "23.11";

  users.mutableUsers = false;
  users.users.root.initialHashedPassword = "$6$VS5faXtlWOZ2fEv0$IqlguGYC/.M.UkSR1i1vZN7/MRafpNBta7Dg3NZ6/QXWTcHK/vL6iY7Q/2Jk4XmF9OBmjDV2AUvhLqCGM2sCl1";
  # users.users.root.initialPassword = "hunter2";
}
