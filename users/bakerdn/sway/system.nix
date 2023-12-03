{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # Needed to use sway
  security.polkit.enable = true;

  # Required since swaylock is installed via home-manager.
  security.pam.services.swaylock = {};
}
