{
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.wrapperFeatures.gtk = true;
  wayland.windowManager.sway.config.modifier = "Mod4";
  wayland.windowManager.sway.config.terminal = "${pkgs.kitty}/bin/kitty";
  wayland.windowManager.sway.config.bars = [
    {command = "${config.programs.waybar.package}/bin/waybar";}
  ];
  wayland.windowManager.sway.config.menu = "wofi --show drun";

  # gaps
  wayland.windowManager.sway.config.gaps.smartBorders = "on";
  wayland.windowManager.sway.config.gaps.smartGaps = false;
  wayland.windowManager.sway.config.gaps.inner = 12;
  wayland.windowManager.sway.config.gaps.outer = 4;

  # framework resolution
  wayland.windowManager.sway.config.output = {
    "BOE 0x095F Unknown" = {
      mode = "2256x1504@60Hz";
      scale = "1.00";
    };
  };

  wayland.windowManager.sway.config.keybindings = let
    mod = config.wayland.windowManager.sway.config.modifier;
  in
    lib.mkOptionDefault
    {
      "${mod}+y" = "border toggle";
      "${mod}+Tab" = "workspace back_and_forth";
    };

  wayland.windowManager.sway.extraConfig = ''
    #bindsym XF86AudioRaiseVolume exec "pw-volume change +5%; pkill -RTMIN+8 waybar"
    #bindsym XF86AudioLowerVolume exec "pw-volume change -5%; pkill -RTMIN+8 waybar"
    #bindsym XF86AudioMute exec "pw-volume mute toggle; pkill -RTMIN+8 waybar"
    bindsym XF86MonBrightnessUp exec "brightnessctl s +5%; pkill -RTMIN+8 waybar"
    bindsym XF86MonBrightnessDown exec "brightnessctl s 5%-; pkill -RTMIN+8 waybar"
  '';

  home.packages = [
    pkgs.brightnessctl
    pkgs.swayidle
    pkgs.swaylock-effects
  ];
}
