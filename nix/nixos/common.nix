{ pkgs, user, isContainer, ... }: {

    imports = [
      ./common/pkgs.nix
    ];

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        warn-dirty = false;
        keep-outputs = true;
        keep-derivations = true;
      };
    };

    # Set your time zone.
    time.timeZone = "Europe/Tallinn";

    programs.zsh.enable = true;
    boot.isContainer = isContainer;
    users.users."${user}" = (
      if !isContainer then {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = ["wheel" "tty"];
      } else {
        isNormalUser = true;
      }
    );
  }
