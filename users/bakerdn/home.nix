{config, ...}: {
  imports = [
    ./firefox
    ./fonts
    ./kitty
    ./git
    ./mpv
    ./neovim
    ./packages.nix
    ./pipewire
    ./sway
    ./sway/waybar.nix
    ./zsh
  ];

  home.stateVersion = "23.11";
}
