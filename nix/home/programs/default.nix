{config, pkgs, lib, ...}:
{
  imports = [
    ./programs.nix
    ./nvim
# nix   ./term/wezterm.nix
  ];
}
