{
  pkgs,
  nix-colors,
  pw-volume,
  ...
}: {
  nix.settings.trusted-users = ["bakerdn"];
  users.users.bakerdn = {
    isNormalUser = true;
    initialHashedPassword = "$6$zo7JRVBVVKUVn047$IbDRNzWNcp1hwO2jFGnH9PbGYh2fwDP52zc1/ggMovCYiuMg7N2d7NcCkAr8//Yc6s66D4/tzt8BuuM1Nap3F1";
    extraGroups = [
      "wheel"
      "networkManager"

      # needed for sway
      "input"

      # needed for audio
      "audio"
    ];

    # needed to make zsh the default shell
    shell = pkgs.zsh;
  };

  # have to enable zsh; HM only configures
  programs.zsh.enable = true;

  imports = [
    ./pipewire/system.nix
    # ./pulseaudio/system.nix
    ./sway/system.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.bakerdn = import ./home.nix;
    extraSpecialArgs = {
      inherit
        nix-colors
        pw-volume
        ;
    };
  };
}
