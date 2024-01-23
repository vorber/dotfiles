{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      git
      zsh
      neovim
      curl
      wget
    ];

    environment.variables.EDITOR = "nvim";
  }
