{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          # encryption does not appear to work in vm test; only use on real system
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        mountpoint = null;
        # postCreateHook = "zfs snapshot zroot@empty";

        datasets = {
          local = {
            type = "zfs_fs";
            options.canmount = "off";
          };

          safe = {
            type = "zfs_fs";
            options.canmount = "off";
          };

          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = ''
              zfs snapshot zroot/local/root@empty
            '';
          };

          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };

          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
            # options."com.sun:auto-snapshot" = "true";
          };

          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
            # options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
  disko.tests.extraChecks = ''
    print("HIIIIIIIIIIIIIIIIIIII")
    print(machine.succeed("pwd"))
    print(machine.succeed("ls -FhoA /"))
    print(machine.succeed("ls -FhoA /nix/store/"))
    print(machine.succeed("zfs list -t snapshot"))
  '';
}
