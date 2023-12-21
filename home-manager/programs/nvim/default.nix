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
    #home.file."./.config/nvim/" = {
        #source = ./../../../nvim;
        #recursive = true;
    #};
    xdg.configFile = {
        nvim = {
            source = 
                config.lib.file.mkOutOfStoreSymlink
                    "${config.home.homeDirectory}/dotfiles/nvim";
            recursive = true;
        };
    };
}
