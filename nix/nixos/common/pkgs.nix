{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      fish
      neovim
      curl
      wget
    ];

    environment.variables.EDITOR = "nvim";
  }
