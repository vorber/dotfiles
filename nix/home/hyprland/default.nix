{config, pkgs, lib, ...}:
let
  launcher = {
    run = "pkill wofi || wofi -S drun";
    pass = "wofi-pass";
  };
in
{
  imports = [
      ./launcher/wofi.nix
        (import ./hyprland.nix {inherit pkgs launcher;})
        (import ./waybar.nix {inherit pkgs config launcher;})
      ./wlogout.nix
      (import ./lock/swaylock.nix {inherit pkgs config;})
  ];
}
