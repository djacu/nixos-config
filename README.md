# nixos-config

## Bootstrapping

To load the bootstrap devShell:

```shell
nix-shell -A devShells.<system>.bootstrap-<host>
```

There should be `bootstrap-*` scripts available for partitioning. Below is the old way for reference.

1. `sudo -i`
1. `nix-shell -p git`
1. Clone and `cd` to repo
1. Wipe the disk(s) with wipefs or something similar
1. `sudo nix run github:nix-community/disko --extra-experimental-features "nix-command flakes" -- --mode disko ./hosts/<host>/disko-config.nix`
1. The system will ask for the ZFS root encryption password; enter it twice.
1. Copy the repo to the mounted drive and `cd` to it.
1. If a `hardware-configuration.nix` file has not been generated yet:
    1. `sudo nixos-generate-config --no-filesystems --root /mnt`
    1. Copy the `hardware-configuration.nix` into the `<host>` directory.
    1. Modify the `<host>` `configuration.nix` file to import the `hardware-configuration.nix` file.
1. `sudo nixos-install --no-root-password --flake .#<host>`
1. Reboot

## Disko

To see what the disko partition script will look like as a dry-run.

```shell
nix run github:nix-community/disko -- --mode disko --dry-run ./hosts/<host>/disko-config.nix
```

## ssh-keys

If using a hardware ssh key:

```shell
eval "$(ssh-agent -s)"
ssh-add -K
```
