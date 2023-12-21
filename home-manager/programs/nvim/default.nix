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
      "nvim/lua".source = ../../../nvim/lua;
      "nvim/after".source = ../../../nvim/after;
      "nvim/ftplugin".source = ../../../nvim/ftplugin;
      "nvim/init.lua".source = ../../../nvim/init.lua;
#      nvim = {
#        source = 
#          config.lib.file.mkOutOfStoreSymlink #../../../nvim;
#          "${config.home.homeDirectory}/dotfiles/nvim";
#        recursive = true;
#      };
    };
}
