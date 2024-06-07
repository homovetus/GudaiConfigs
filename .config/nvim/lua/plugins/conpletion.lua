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
		init = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
		end,
		config = function()
			local cmp = require("cmp")
			cmp.setup({
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
			})
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
		"Exafunction/codeium.vim",
		event = "BufEnter",
	},
}
