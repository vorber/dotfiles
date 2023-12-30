{ pkgs, flakeName ? "myFlake", isNixOS ? false, ... }: 
let 
  lib = pkgs.lib;
in rec {
  hmConfig = let
    inherit (pkgs.stdenv) isLinux;
  in {
    options = {
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
      inherit isNixOS;
      inherit flakeName;
    };
  };
  modules = [hmConfig] ++ [ ./home.nix ];
}

