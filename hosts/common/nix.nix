{
  config,
  nixpkgs,
  ...
}: {
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        # cache.nixos.org is added by default
        # "https://cache.nixos.org/"
        "https://nixpkgs-wayland.cachix.org/"
      ];
      trusted-public-keys = [
        # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    };
  };
}
