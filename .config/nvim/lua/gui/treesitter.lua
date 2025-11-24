return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		opts = {
			auto_install = true,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>",
					node_decremental = "<bs>",
					node_incremental = "<cr>",
					scope_incremental = false,
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			textobjects = {
				select = {
					enable = true,
					include_surrounding_whitespace = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
					lookahead = true,
					selection_modes = {
						['@function.outer'] = 'V',
						['@function.inner'] = 'V',
					},
				},
			},
		},
	},
}
