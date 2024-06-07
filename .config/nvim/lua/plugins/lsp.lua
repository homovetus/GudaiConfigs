return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				c = { "clangtidy" },
				cpp = { "clangtidy" },
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
			"folke/lazydev.nvim",
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
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},
}
