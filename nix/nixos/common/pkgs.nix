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
      jq
      lz4
    ];

    environment.variables.EDITOR = "nvim";
  }
