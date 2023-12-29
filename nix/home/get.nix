{ pkgs, flakeName ? "myFlake", isNixOS ? false, ... }: 
let 
  lib = pkgs.lib;
in rec {
  hmStandaloneConfig = let
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
      targets.genericLinux.enable = isLinux;
      xdg.mime.enable = isLinux;
      inherit isNixOS;
      inherit flakeName;
    };
  };
  modules = (lib.optionals (!isNixOS) [hmStandaloneConfig])
  ++ [ ./home.nix ];
}

