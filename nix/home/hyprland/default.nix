{config, pkgs, lib, inputs, ...}:
let
  launcher = {
    # Toggle wofi; launch the chosen desktop entry via `uwsm app` so it runs as
    # its own systemd scope (entry.desktop[:action] form, per the UWSM README).
    run = toString (pkgs.writeShellScript "launcher" ''
      ${pkgs.procps}/bin/pkill wofi && exit 0
      entry=$(${pkgs.wofi}/bin/wofi --show drun --define=drun-print_desktop_file=true) || exit 0
      [ -n "$entry" ] || exit 0
      exec uwsm app -- "$(printf '%s' "$entry" | ${pkgs.gnused}/bin/sed -E 's/(\.desktop) /\1:/')"
    '');
    pass = "wofi-pass";
  };
  waybar = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
in
{
  imports = [
      ./launcher/wofi.nix
      ./notifications/dunst.nix
        (import ./hyprland.nix {inherit pkgs lib inputs launcher;})
        (import ./waybar.nix {inherit pkgs config launcher waybar;})
      ./wlogout.nix
      # (import ./lock/swaylock.nix {inherit pkgs config;})
      (import ./lock/hyprlock.nix {inherit pkgs config;})
  ];
}
