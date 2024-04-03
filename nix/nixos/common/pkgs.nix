{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      fish
      neovim
      curl
      wget
      pass
      tealdeer
      killall
    ];

    environment.variables.EDITOR = "nvim";
  }
