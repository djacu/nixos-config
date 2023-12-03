{pkgs, ...}: {
  home.packages = with pkgs; [
    mako # notification daemon

    # console utilities
    wget
    bat
    ripgrep
    fd
    jq

    # social
    discord
  ];
}
