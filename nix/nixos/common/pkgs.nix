{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      fish
      neovim
      curl
      wget
      pass
      tealdeer
    ];

    environment.variables.EDITOR = "nvim";
  }
