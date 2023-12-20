{ config, lib, pkgs, ...}:
let
    fromGithub = import ../../functions/vimPlugFromGitHub.nix;
in
{
#home.packages = [ pkgs.neovim ];
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
            #vim-sensible

            {
                plugin = telescope-nvim;
                type = "lua";
                config = builtins.readFile(./config/lua/plugins/telescope.lua);
            }

        {
            plugin = nvim-treesitter.withAllGrammars;
            type = "lua";
            config = builtins.readFile(./config/lua/plugins/treesitter.lua);
        }

        {
            plugin = fidget-nvim;
            type = "lua";
            config = builtins.readFile(./config/lua/plugins/fidget.lua);
        }

        {
            plugin = nvim-lspconfig;
            type = "lua";
            config = builtins.readFile(./config/lua/plugins/lsp.lua);
        }

#{
#plugin = undotree;
#type = "lua";
#config = ''
#require('undotree').setup()
#'';
#}

        trouble-nvim #todo: config?

        {
            plugin = nvim-autopairs;
            type = "lua";
            config = ''
                require("nvim-autopairs").setup({})
                '';
        }

        vim-fugitive

# F#
            Ionide-vim

            {
                plugin = leap-nvim;
                type = "lua";
                config = builtins.readFile(./config/lua/plugins/leap.lua);
            }
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

        extraLuaConfig = builtins.readFile(./config/lua/vorber.lua);
#    extraConfig = ''
#      :luafile = ~/.config/nvim/lua/init.lua 
#    '';
    };

#    xdg.configFile.nvim = {
#        source = ./config;
#        recursive = true;
#    };
}
