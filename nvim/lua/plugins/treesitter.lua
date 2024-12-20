table.unpack = table.unpack or unpack
return
{
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { 
                    "c",
                    "c_sharp",
                    "lua",
                    "vim",
                    "vimdoc",
                    "javascript",
                    "html",
                    "bash",
                    "nix",
                    "toml",
                    table.unpack(additional_treesitter_languages or {})
                },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
