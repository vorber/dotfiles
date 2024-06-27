{config, pkgs, lib, ...}:
let
  cfg = config.games;
in 
with lib;
{
  options = {
    games.enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Install gaming packages.
        '';
    };
  };
  
  config = mkIf cfg.enable {
    home.packages = with pkgs;[
      steam
      scanmem
      steamtinkerlaunch
    ];
  };
}
