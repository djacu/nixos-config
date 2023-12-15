{
  # nix build .#nixosConfigurations.adalon.config.system.build.installTest -L
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    disko = {
      url = "github:nix-community/disko/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    sway-tools.url = "github:smasher164/sway-tools";
  };
  outputs = {
    self,
    nixpkgs,
    disko,
    flake-compat,
    home-manager,
    impermanence,
    nix-colors,
    nixos-hardware,
    nixpkgs-wayland,
    nur,
    sway-tools,
  } @ inputs: let
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
        nixos-hardware.nixosModules.framework-11th-gen-intel
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        ./hosts/adalon/configuration.nix
        ./users/bakerdn
        ({...}: {
          nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
          };
        })
      ];

      specialArgs = {
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";
        inherit
          nixpkgs
          nix-colors
          ;
        pw-volume = sway-tools.packages.${system}.pw-volume;
      };
    };

    checks.x86_64-linux.adalon = self.nixosConfigurations.adalon.config.system.build.installTest;

    devShells.x86_64-linux = (
      lib.mapAttrs'
      (
        name: value:
          lib.nameValuePair
          ("bootstrap-" + name)
          (
            pkgs.mkShell {
              packages = [
                (bootstrap system name)
              ];

              NIX_CONFIG = ''
                extra-experimental-features = nix-command flakes
              '';
            }
          )
      )
      (
        lib.filterAttrs
        (name: value: name != "common" && value == "directory")
        (builtins.readDir ./hosts)
      )
    );
  };
}
