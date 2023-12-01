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
    test-echo =
      pkgs.writeShellScriptBin
      "test-echo"
      ''
        echo ${host}
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
