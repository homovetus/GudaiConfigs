return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
		opts = function()
			local cmp = require("cmp")
			return {
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<c-u>"] = cmp.mapping.scroll_docs(-4),
					["<c-d>"] = cmp.mapping.scroll_docs(4),
					["<c-space>"] = cmp.mapping.complete(),
					["<c-e>"] = cmp.mapping.abort(),
					["<cr>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" }, { name = "vsnip" } },
					{ { name = "buffer" }, { name = "path" } }
				),
			}
		end,
		config = function(_, opts)
			local cmp = require("cmp")
			cmp.setup(opts)
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
	{
		"echasnovski/mini.comment",
		opts = {},
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
		"mfussenegger/nvim-lint",
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				-- c = { "clangtidy" },
				-- cpp = { "clangtidy" },
				-- lua = { "selene" },
				python = { "ruff" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("lspconfig.ui.windows").default_options.border = "rounded"
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ui = { border = "rounded" },
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/nvim-cmp",
		},
		opts = {
			ensure_installed = {
				"clangd",
				"lua_ls",
				"powershell_es",
				"pyright",
			},
			handlers = {
				function(server_name)
					local capabilities = require("cmp_nvim_lsp").default_capabilities()
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		},
	},
	{
		"folke/neodev.nvim",
		opts = {},
	},
	{
		"echasnovski/mini.pairs",
		opts = {},
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
			shell = "pwsh",
			direction = "float",
			float_opts = { border = "curved" },
			open_mapping = [[<c-\>]],
		},
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
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		keys = {
			{ "<cr>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		opts = {
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>",
					node_incremental = "<cr>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
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
