return {
	{
		"echasnovski/mini.animate",
		opts = {},
	},
	{
		"typicode/bg.nvim",
		lazy = false,
	},
	{
		"nvimdev/dashboard-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		keys = {
			{ "<leader>d", "<cmd>Dashboard<cr>", desc = "Dashboard" },
		},
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
			options = {
				component_separators = { left = "|", right = "|" },
				section_separators = "",
			},
			sections = {
				lualine_x = {
					"encoding",
					{ "fileformat", symbols = { unix = [[LF]], dos = [[CRLF]], mac = [[CR]] } },
					"filetype",
				},
			},
		},
	},
	{
		"vimpostor/vim-lumen",
		init = function()
			vim.g.lumen_light_colorscheme = "tokyonight-day"
			vim.g.lumen_dark_colorscheme = "tokyonight-night"
		end,
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
