{config, ...}: {
  imports = [
    ./git.nix
    ./neovim
  ];

  home.stateVersion = "23.11";
}
