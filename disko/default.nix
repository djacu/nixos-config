{device, ...}: {
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        inherit device;
        content = {
          type = "gpt";
          partitions = {
            biosboot = {
              size = "1M";
              type = "EF02";
            };
            efiboot = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "1G";
              type = "8200";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true; # resume from hiberation from this device
              };
            };
            zroot = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          checksum = "edonr";
          compression = "zstd";
          dnodesize = "auto";
          # encryption does not appear to work in vm test; only use on real system
          #encryption = "aes-256-gcm";
          #keyformat = "passphrase";
          #keylocation = "file:///tmp/secret.key"; # must be set during initial installation step
          mountpoint = "none";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        #postCreateHook = ''
        #  # last argument must be same as as the pool attrname
        #  zfs set keylocation="prompt" "rpool";
        #'';

        datasets = {
          home = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
            postCreateHook = "zfs snapshot rpool/home@empty";
          };
          persist = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "true";
            postCreateHook = "zfs snapshot rpool/persist@empty";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "true";
            };
            postCreateHook = "zfs snapshot rpool/nix@empty";
          };
          root = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
            postCreateHook = ''
              zfs snapshot rpool/root@empty
              zfs snapshot rpool/root@lastboot
            '';
          };
        };
      };
    };
  };
}
