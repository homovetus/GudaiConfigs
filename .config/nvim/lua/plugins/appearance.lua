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
███████╗██╗   ██╗██████╗ ███████╗██████╗    ███████╗ ██████╗  ██████╗██╗   ██╗███████╗   ██╗
██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗   ██╔════╝██╔═══██╗██╔════╝██║   ██║██╔════╝   ██║
███████╗██║   ██║██████╔╝█████╗  ██████╔╝   █████╗  ██║   ██║██║     ██║   ██║███████╗   ██║
╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗   ██╔══╝  ██║   ██║██║     ██║   ██║╚════██║   ╚═╝
███████║╚██████╔╝██║     ███████╗██║  ██║   ██║     ╚██████╔╝╚██████╗╚██████╔╝███████║   ██╗
╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝
]]
			return {
				config = {
					header = vim.split(logo, "\n"),
					packages = { enable = false },
					shortcut = {
						{ desc = " Man", group = "DevIconBash", action = "Telescope man_pages", key = "m" },
						{ desc = " Old", group = "DevIconCpp", action = "Telescope oldfiles", key = "o" },
						{ desc = "󰊳 Sync", group = "DevIconAstro", action = "Lazy sync", key = "s" },
					},
					mru = { limit = 5 },
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
			vim.cmd("colorscheme tokyonight")
		end,
		opts = {
			terminal_colors = false,
		},
	},
}
