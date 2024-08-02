return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				c = { "clangtidy" },
				cpp = { "clangtidy" },
				html = { "htmlhint" },
				javascript = { "oxlint" },
				python = { "ruff" },
				typescript = { "oxlint" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
		build = ":MasonInstall clangtidy htmlhint oxlint ruff",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/lazydev.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		init = function()
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end
					local bufnr = args.buf
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = bufnr,
						callback = function()
							vim.diagnostic.open_float(nil, {
								focusable = false,
								close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
								border = "rounded",
								source = "always",
								prefix = " ",
								scope = "cursor",
							})
						end,
					})
					if client.supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
					if client.supports_method("textDocument/codeAction") then
						vim.keymap.set(
							"n",
							"ga",
							[[<cmd>lua vim.lsp.buf.code_action()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/definition") then
						vim.keymap.set(
							"n",
							"gd",
							[[<cmd>lua vim.lsp.buf.definition()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/declaration") then
						vim.keymap.set(
							"n",
							"gD",
							[[<cmd>lua vim.lsp.buf.declaration()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/implementation") then
						vim.keymap.set(
							"n",
							"gI",
							[[<cmd>lua vim.lsp.buf.implementation()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/references") then
						vim.keymap.set(
							"n",
							"gr",
							[[<cmd>lua vim.lsp.buf.references()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/rename") then
						vim.keymap.set(
							"n",
							"gR",
							[[<cmd>lua vim.lsp.buf.rename()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/signatureHelp") then
						vim.keymap.set(
							"n",
							"gs",
							[[<cmd>lua vim.lsp.buf.signature_help()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
						vim.keymap.set(
							"i",
							"<c-s>",
							[[<cmd>lua vim.lsp.buf.signature_help()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
					if client.supports_method("textDocument/typeDefinition") then
						vim.keymap.set(
							"n",
							"gk",
							[[<cmd>lua vim.lsp.buf.type_definition()<cr>]],
							{ noremap = true, buffer = bufnr }
						)
					end
				end,
			})
		end,
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
                                "bashls",
				"clangd",
				"lua_ls",
				"powershell_es",
				"pyright",
				"rust_analyzer",
				"html",
				"jsonls",
				"tsserver",
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
