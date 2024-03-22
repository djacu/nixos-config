{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    vim
    wget
  ];
}
