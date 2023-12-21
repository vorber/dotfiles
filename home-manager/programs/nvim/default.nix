{ config, lib, pkgs, ...}:
{
    home.packages = with pkgs; [
        neovim 
        tree-sitter
        lua-language-server
        nil
        nixpkgs-fmt
        ripgrep
        fd
    ];

    xdg.configFile = {
      nvim = {
        source = 
          config.lib.file.mkOutOfStoreSymlink ../../../nvim;
          #"${config.home.homeDirectory}/dotfiles/nvim";
        recursive = true;
      };
    };
}
