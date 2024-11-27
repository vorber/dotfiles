return {
    'jedrzejboczar/exrc.nvim',
    dependencies = {'neovim/nvim-lspconfig'}, -- (optional)
    config = true,
    opts = {
        on_vim_enter = true,
        on_dir_changed = { -- Automatically load exrc files on DirChanged autocmd
            enabled = true,
            -- Wait until CursorHold and use vim.ui.select to confirm files to load, instead of loading unconditionally
            use_ui_select = true,
        },
        trust_on_write = true, -- Automatically trust when saving exrc file
        use_telescope = true, -- Use telescope instead of vim.ui.select for picking files (if available)
        min_log_level = vim.log.levels.DEBUG, -- Disable notifications below this level (TRACE=most logs)
        lsp = {
            auto_setup = false, -- Automatically configure lspconfig to register on_new_config
        },
        commands = {
            instant_edit_single = true, -- Do not use vim.ui.select if there is only 1 candidate for ExrcEdit* commands
        },
    }
}
