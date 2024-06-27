{pkgs, lib, ...}: {
    environment.systemPackages = with pkgs; [
      fish
      neovim
      curl
      wget
      pass
      keepassxc
      tealdeer
      killall
    ];

    environment.variables.EDITOR = "nvim";
  }
