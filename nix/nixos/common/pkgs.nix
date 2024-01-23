{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      zsh
      neovim
      curl
      wget
    ];

    environment.variables.EDITOR = "nvim";
  }
