require("plugins")
require("vorber")
--todo: find a better place
vim.g['fsharp#fsautocomplete_command'] = {
  'dotnet',
  'fsautocomplete',
  '--background-service-enabled'
}
vim.lsp.enable('lua_ls')
vim.lsp.enable('nil_ls')


-- bootstrap lazy.nvim - the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

