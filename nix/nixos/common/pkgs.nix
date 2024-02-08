{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      fish
      neovim
      curl
      wget
      pass
    ];

    environment.variables.EDITOR = "nvim";
  }
