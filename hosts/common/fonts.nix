{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;

    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      fira-code-symbols

      (nerdfonts.override {
        fonts = ["FiraCode"];
      })
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        monospace = ["Noto Mono" "FiraCode"];
      };
    };
  };
}
