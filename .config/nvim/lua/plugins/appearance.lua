return {
	{
		"echasnovski/mini.animate",
		opts = {},
	},
	{
		"nvimdev/dashboard-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		opts = function()
			local logo = [[
            ███████╗██╗   ██╗██████╗ ███████╗██████╗     ███████╗ ██████╗  ██████╗██╗   ██╗███████╗    ██╗
            ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗    ██╔════╝██╔═══██╗██╔════╝██║   ██║██╔════╝    ██║
            ███████╗██║   ██║██████╔╝█████╗  ██████╔╝    █████╗  ██║   ██║██║     ██║   ██║███████╗    ██║
            ╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗    ██╔══╝  ██║   ██║██║     ██║   ██║╚════██║    ╚═╝
            ███████║╚██████╔╝██║     ███████╗██║  ██║    ██║     ╚██████╔╝╚██████╗╚██████╔╝███████║    ██╗
            ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝    ╚═╝      ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝    ╚═╝
            ]]
			return {
				config = {
					header = vim.split(logo, "\n"),
					packages = { enable = false },
					shortcut = {
						{ desc = "󰊳 Sync", group = "@property", action = "Lazy sync", key = "s" },
						{ desc = " Man", group = "Label", action = "Telescope man_pages", key = "m" },
					},
					footer = {},
				},
			}
		end,
	},
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
