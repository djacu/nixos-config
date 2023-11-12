{config, ...}: {
  nix.settings.trusted-users = ["bakerdn"];
  users.users.bakerdn = {
    isNormalUser = true;
    initialHashedPassword = "$6$zo7JRVBVVKUVn047$IbDRNzWNcp1hwO2jFGnH9PbGYh2fwDP52zc1/ggMovCYiuMg7N2d7NcCkAr8//Yc6s66D4/tzt8BuuM1Nap3F1";
    extraGroups = [
      "wheel"
      "networkManager"
    ];
  };
}
