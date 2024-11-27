local on_attach = function(_, bufnr)
    vim.print("attaching:", bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local nmap = function(mode, keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('n', "K", vim.lsp.buf.hover, "Hover Documentation")
    nmap('n', "C-k", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap('n', "<leader>rr", vim.lsp.buf.rename, "[R]efactor - [R]ename")
    nmap('n', "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap('n', "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap('n', "gr", require('telescope.builtin').lsp_references, "[G]oto  [R]eferences")
    nmap('n', "gI", vim.lsp.buf.implementation, "[G]oto  [I]mplementation")
    nmap('n', "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

    nmap('n', "<leader>ds", require('telescope.builtin').lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap('n', "<leader>ws", require('telescope.builtin').lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })

    vim.api.nvim_buf_create_user_command(bufnr, "RefreshCodeLens", function()
        vim.lsp.codelens.refresh()
        print "Refreshing CodeLens"
    end, {
        bang = true,
    })
    vim.print("attached:", bufnr)
end

local get_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    return capabilities
end

local M = {
    lsp_on_attach = on_attach,
    lsp_client_capabilities = get_capabilities
}

return M


