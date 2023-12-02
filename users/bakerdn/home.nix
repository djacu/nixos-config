{config, ...}: {
  imports = [
    ./git.nix
    ./neovim
    ./zsh
  ];

  home.stateVersion = "23.11";
}
