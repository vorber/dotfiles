{ pkgs, settings, ... }: 
let 
  lib = pkgs.lib;
  isNixOS = settings.isNixOS or false;
  flakeName = settings.flakeName or "vorber";

in rec {
  hmConfig = let
    inherit (pkgs.stdenv) isLinux;
  in {
    options = {#TODO: refactor to use single attr set?
      isNixOS = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Are we running on NixOS?";
      };
      flakeName = lib.mkOption {
        type = lib.types.str;
        default = "home-manager";
        description = "The name of the flake to use for home-manager";
      };
    };
    config = {
      targets.genericLinux.enable = isLinux && !isNixOS;
      xdg.mime.enable = isLinux && !isNixOS;
      games.enable = settings.games.enable or false;
      inherit isNixOS;
      inherit flakeName;
    };
  };
  modules = [hmConfig] ++ [ ./home.nix ];
}

