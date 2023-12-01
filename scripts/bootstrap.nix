{
  pkgs,
  lib,
  disko,
}: system: host: let
  scripts = {
    disko-dry-run =
      pkgs.writeShellScriptBin
      "disko-dry-run"
      ''
        #!/usr/bin/env bash
        disko --mode disko --dry-run ./hosts/${host}/disko-config.nix
      '';
    bootstrap-disko-partition =
      pkgs.writeShellScriptBin
      "bootstrap-disko-partition"
      ''
        #!/usr/bin/env bash
        disko --mode disko ./hosts/${host}/disko-config.nix
      '';
    bootstrap-generate-config =
      pkgs.writeShellScriptBin
      "bootstrap-generate-config"
      ''
        #!/usr/bin/env bash
        nixos-generate-config --no-filesystems --root /mnt
      '';
    bootstrap-install =
      pkgs.writeShellScriptBin
      "bootstrap-install"
      ''
        #!/usr/bin/env bash
        nixos-install --no-root-password --flake .#${host}
      '';
  };
in
  pkgs.symlinkJoin {
    name = "bootstrap";
    paths =
      [(builtins.attrValues scripts)]
      ++ [
        pkgs.git
        disko.packages.${system}.default
      ];
    buildInputs = [pkgs.makeWrapper];
    postBuild =
      lib.concatStringsSep
      "\n"
      (
        lib.mapAttrsToList
        (
          name: value: "wrapProgram $out/bin/${value.name} --prefix PATH : $out/bin"
        )
        scripts
      );
  }
