return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = { icons_enabled = false },
		},
		init = function()
			vim.opt.showmode = false
		end,
	},
	{
		"vimpostor/vim-lumen",
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			terminal_colors = false,
		},
		init = function()
			vim.opt.termguicolors = true
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
