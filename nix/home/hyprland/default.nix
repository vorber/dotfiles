{config, pkgs, lib, ...}:
let
  launcher = "pkill wofi || wofi -S drun";
in
{
  imports = [
      ./launcher/wofi.nix
        (import ./hyprland.nix {inherit pkgs launcher;})
        (import ./waybar.nix {inherit pkgs config launcher;})
      ./wlogout.nix
  ];
}
