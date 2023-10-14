{config, ...}: {
  nix.settings.trusted-users = ["bakerdn"];
  users.users.bakerdn = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "networkManager"
    ];
  };
}
