{lib, ...}: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/local/root@empty
  '';

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
