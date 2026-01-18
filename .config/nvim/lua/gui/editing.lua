return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter", },
			{ "r", mode = { "x", "o" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash", },
		},
		opts = {
			labels = "arstdhneioqwfpgjluyzxcvbkm",
			label = { uppercase = false },
		},
	},
	{
		"shabaraba/ime-auto.nvim",
		event = "InsertEnter",
		opts = {
			os = "auto", -- OS設定: "auto", "macos", "windows", "linux"
		}
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
}
