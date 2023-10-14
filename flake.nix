{
  # nix build .#nixosConfiguration.adalon.config.system.build.installTest -L
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };
  outputs = {
    self,
    nixpkgs,
    disko,
    nixpkgs-wayland,
    nur,
  }: let
    overlays = [
      nixpkgs-wayland.overlay
      nur.overlay
    ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    system = "x86_64-linux";
  in {
    nixosConfiguration.adalon = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        disko.nixosModules.default
        ./disko/default.nix
        ./hosts/adalon/configuration.nix
        ./users/bakerdn
      ];

      specialArgs = {
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";
        inherit nixpkgs;
      };
    };
  };
}
