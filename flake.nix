{
  # nix build .#nixosConfiguration.adalon.config.system.build.installTest -L
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko/";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    disko,
    nixpkgs-wayland,
  }: let
    overlays = [
      nixpkgs-wayland.overlay
    ];
  in {
    nixosConfiguration.adalon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.default
        ./disko/default.nix
        ./hosts/adalon/configuration.nix
        ./users/bakerdn.nix
      ];
      specialArgs = {
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";
        inherit nixpkgs overlays;
      };
    };
  };
}
