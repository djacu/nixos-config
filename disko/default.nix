{
  disks ? [
    "nvme-WD_BLACK_SN850_1TB_204178806629"
  ],
}: let
  disksByPath = disk: "/dev/disk/by-id/${disk}";

  disk = {inherit nvme;};

  nvme = {
    type = "disk";
    device = disksByPath (builtins.elemAt disks 0);
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = "bootcode";
          start = "0";
          end = "1M";
          part-type = "primary";
          flags = ["bios_grub"];
        }
        {
          name = "efiboot";
          fs-type = "fat32";
          start = "1MiB";
          end = "1GiB";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        }
        {
          name = "swap";
          start = "1GiB";
          end = "17GiB";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
        {
          name = "zroot";
          start = "17GiB";
          end = "100%";
          content = {
            type = "zfs";
            pool = "rpool";
          };
        }
      ];
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
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "file:///tmp/secret.key"; # must be set during initial installation step
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
      postCreateHook = ''
        zfs set keylocation="prompt" $name;
      '';

      datasets = {
        reserved = {
          options = {
            canmount = "off";
            mountpoint = "none";
            reservation = "5GiB";
          };
          type = "zfs_fs";
        };
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
in {
  disko.devices = {inherit disk zpool;};
}
