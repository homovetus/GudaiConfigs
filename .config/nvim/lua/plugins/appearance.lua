return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.opt.showmode = false
		end,
		opts = {
			options = { icons_enabled = false },
		},
	},
	{
		"vimpostor/vim-lumen",
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.opt.termguicolors = true
			vim.cmd([[colorscheme tokyonight]])
		end,
		opts = {
			transparent = true,
			terminal_colors = false,
		},
	},
}
