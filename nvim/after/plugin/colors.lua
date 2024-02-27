
function TweakColors(color)
	color = color or "nord"--"rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg  = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg  = "none" })
end

require("notify").setup({
    background_colour = "#000000",
})

TweakColors("catppuccin")
