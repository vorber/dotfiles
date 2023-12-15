{ config, lib, pkgs, ...}:
let
  fromGithub = import ../../functions/vimPlugFromGitHub.nix;
in
{
  imports = [
    ./colorscheme.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible

      telescope-nvim
      nvim-treesitter.withAllGrammars
      nvim-lspconfig

      undotree

      fidget-nvim
      trouble-nvim

      nvim-autopairs

      vim-fugitive

      # F#
      Ionide-vim

      leap-nvim

      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      nvim-cmp

      luasnip
      cmp_luasnip      
    ];

    extraPackages = with pkgs; [
      tree-sitter
      lua-language-server
      nil
      nixpkgs-fmt
      ripgrep
      fd
    ];

    extraConfig = ''
      set number relativenumber
      :luafile = ${./config/lua/init.lua} 
    '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
