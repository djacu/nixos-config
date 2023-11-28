# nixos-config

## Bootstrapping

- `sudo -i`
- `nix-shell -p git`
- Clone and `cd` to repo
- `sudo nix run github:nix-community/disko --extra-experimental-features "nix-command flakes" -- --mode disko ./hosts/<host>/disko-config.nix`
- The system will ask for the ZFS root encryption password; enter it twice.
- `sudo nixos-generate-config --no-filesystems --root /mnt`
- Copy the repo to the mounted drive and `cd` to it.
- If not already in the repo, copy the `hardware-configuration.nix` into the `<host>` directory.
- Modify the `<host>` `configuration.nix` file to import the `hardware-configuration.nix` file.
- `sudo nixos-install --flake .#<host>`
- The system will ask for the root user password; enter it twice.
  (Note: Try with `--no-root-password` since it is already hashed in the config.)
- Reboot
