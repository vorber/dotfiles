{config, pkgs, lib, ...}:
{
  imports = [
    ./programs.nix
    ./games.nix
    ./nvim
# nix   ./term/wezterm.nix
  ];
}
