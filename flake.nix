{
  # nix build .#nixosConfigurations.adalon.config.system.build.installTest -L
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
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
    flake-compat,
    nixos-hardware,
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

    inherit (pkgs) lib;

    system = "x86_64-linux";

    bootstrap = import ./scripts/bootstrap.nix {inherit pkgs lib disko;};
  in {
    nixosConfigurations.adalon = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        disko.nixosModules.default
        nixos-hardware.nixosModules.framework
        ./hosts/adalon/configuration.nix
        ./users/bakerdn
      ];

      specialArgs = {
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";
        inherit nixpkgs;
      };
    };

    checks.x86_64-linux.adalon = self.nixosConfigurations.adalon.config.system.build.installTest;

    devShells.x86_64-linux.bootstrap = pkgs.mkShell {
      packages = [
        (bootstrap "${system}" "adalon")
      ];

      NIX_CONFIG = ''
        extra-experimental-features = nix-command flakes
      '';
    };

    packages.x86_64-linux.bootstrap = bootstrap "${system}" "adalon";
  };
}
