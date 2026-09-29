{config, pkgs, lib, inputs, ...}:
let
  launcher = {
    run = "pkill wofi || wofi -S drun";
    pass = "wofi-pass";
  };
  waybar = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
in
{
  imports = [
      ./launcher/wofi.nix
      ./notifications/dunst.nix
        (import ./hyprland.nix {inherit pkgs lib inputs launcher waybar;})
        (import ./waybar.nix {inherit pkgs config launcher waybar;})
      ./wlogout.nix
      # (import ./lock/swaylock.nix {inherit pkgs config;})
      (import ./lock/hyprlock.nix {inherit pkgs config;})
  ];
}
