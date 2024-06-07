return {
	{
		"bkad/CamelCaseMotion",
		init = function()
			vim.g.camelcasemotion_key = "<leader>"
		end,
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
				json = { "prettier" },
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
				"<leader><space>",
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
		"echasnovski/mini.pairs",
		opts = {},
	},
	{
		"tpope/vim-surround",
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
			{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
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
		config = function(_, opts)
			require("telescope").setup(opts)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			autochdir = true,
			direction = "float",
			float_opts = { border = "curved" },
			open_mapping = [[<c-\>]],
		},
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
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {},
	},
}
