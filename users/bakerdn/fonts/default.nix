{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    (nerdfonts.override {
      fonts = ["FiraCode"];
    })
  ];
}
