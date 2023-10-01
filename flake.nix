{
# nix build .#nixosConfiguration.adalon.config.system.build.installTest -L
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko/";
  };
  outputs = {
    self,
    nixpkgs,
    disko,
  }: {
    nixosConfiguration.adalon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.default
        ./disko/default.nix
        ({config, ...}: {
          networking.hostId = "00000000";
          services.zfs.autoScrub.enable = true;
          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };
          boot = {
            kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
            supportedFilesystems = ["zfs"];
          };
        })
      ];
      specialArgs = {device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";};
    };
  };
}
