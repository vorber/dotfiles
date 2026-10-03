{ config, pkgs, ... }:
let
  palette = config.colorScheme.palette;

  # hyprlock (like swaylock) can crash when a monitor is hotplugged while
  # locked. Hyprland keeps the session locked; with
  # misc.allow_session_lock_restore a new locker can take over, so respawn it
  # until it exits cleanly (i.e. after a real unlock).
  lockSession = pkgs.writeShellScriptBin "lock-session" ''
    ${pkgs.procps}/bin/pgrep -xu "$UID" hyprlock >/dev/null && exit 0
    for _ in $(seq 20); do
      ${config.programs.hyprlock.package}/bin/hyprlock "$@" && exit 0
      sleep 1
    done
    exit 1
  '';
in
{
  home.packages = [ lockSession ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general.ignore-empty-input = false;
      general.immediate_render = true;
      background = [{
        path = "~/Pictures/wallpaper.png";
        blur_passes = 3;
        blur_size = 8;
      }];
      # shape = [
      #   {
      #     size = "360, 60";
      #     rounding = -1;
      #     color = "rgba(0,0,0,0.0)";
      #     border_color = "0xff${palette.base07}";
      #     border_size = 4;
      #     position = "0, 80";
      #     halign = "center";
      #     valign = "center";
      #   }
      # ];
      input-field = [
        {
          size = "200, 50";
          position = "0, 0";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 5;
          shadow_passes = 1;
          outer_color = "0xff${palette.base07}";
          inner_color = "0xff${palette.base00}";
          font_color = "0xff${palette.base05}";
        }
      ];
    };
  };
}
