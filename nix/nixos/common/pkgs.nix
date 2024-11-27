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
      lact
    ];

    environment.variables.EDITOR = "nvim";
  }
