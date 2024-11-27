vim.keymap.set('n', "<leader>e", vim.diagnostic.open_float)
vim.keymap.set('n', "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set('n', "]d", vim.diagnostic.goto_next)
vim.keymap.set('n', "[d", vim.diagnostic.goto_prev)

local servers = { 'nil_ls' } -- use exrc/.nvim.lua to set up project-specific lsps

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp_common = require('vorber.lsp_common')

local setup = function(server)
    server.setup {
        autostart = true,
        on_attach = lsp_common.lsp_on_attach,
        flags = {
            debounce_text_changes = 150,
        },
       capabilities = lsp_common.lsp_client_capabilities(),
    }
end

for _, lsp in ipairs(servers) do
    setup(require('lspconfig')[lsp])
end

-- setup stuff for lua, since all configs are in it anyway
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').lua_ls.setup {
    on_attach = lsp_common.lsp_on_attach,
    capabilities = lsp_common.lsp_client_capabilities(),
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim', 'require' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
}

--TODO: extract cmp into it's own config
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local lspkind = require('lspkind')

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } } })
})
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer' }
    },
    --formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
            })
        }),
    },
})
