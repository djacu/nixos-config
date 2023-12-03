{config, ...}: {
  imports = [
    ./fonts
    ./kitty
    ./git.nix
    ./neovim
    ./pipewire
    ./sway
    ./sway/waybar.nix
    ./zsh
  ];

  home.stateVersion = "23.11";
}
