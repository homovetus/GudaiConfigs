return {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "BufWinEnter",
		keys = {
			{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Buffer Pick" },
			{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Buffer Pick Close" },
		},
		opts = {
			options = {
				close_command = ":bn|bd#",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "NvimTree",
						separator = " ",
						text = "File Explorer",
						text_align = "center",
					},
				},
			},
		},
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
				html = { "prettier" },
				json = { "prettier" },
				javascript = { "prettier" },
				lua = { "stylua" },
				python = { "ruff_format" },
				["*"] = { "trim_whitespace" },
			},
		},
	},
	{
		"willothy/flatten.nvim",
		lazy = false,
		priority = 1001,
		opts = {
			window = { open = "alternate" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"s",
				function()
					require("flash").jump()
				end,
				desc = "Flash",
				mode = { "n", "x", "o" },
			},
		},
		opts = {
			label = { uppercase = false },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	{
		"echasnovski/mini.pairs",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
			{ "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
		},
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
				},
			},
		},
	},
	{
		"akinsho/toggleterm.nvim",
		opts = function()
			local opts = {
				autochdir = true,
				direction = "float",
				float_opts = { border = "curved" },
				open_mapping = [[<c-\>]],
			}
			if vim.fn.has("win32") == 1 then
				opts.shell = "pwsh"
			end
			return opts
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
		},
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		opts = {
			actions = { change_dir = { global = true } },
			disable_netrw = true,
			renderer = { group_empty = true },
			sync_root_with_cwd = true,
			view = { relativenumber = true },
		},
	},
	{
		"hedyhli/outline.nvim",
		cmd = "Outline",
		keys = {
			{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" },
		},
		opts = {},
	},
	{
		"folke/which-key.nvim",
		dependencies = {
			"echasnovski/mini.icons",
		},
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {},
	},
}
