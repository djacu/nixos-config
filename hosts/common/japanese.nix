{pkgs, ...}: {
  config = {
    i18n.inputMethod.enabled = "fcitx5";
    i18n.inputMethod.fcitx5.addons = [
      pkgs.fcitx5-mozc
      pkgs.fcitx5-gtk
      pkgs.fcitx5-configtool
    ];

    # Would normally set this to fcitx, but kitty only supports ibus, and fcitx
    # provides an ibus interface. Can't use ibus for e.g. QT_IM_MODULE though,
    # because that at least breaks mumble
    environment.variables.GLFW_IM_MODULE = "ibus";
  };
}
