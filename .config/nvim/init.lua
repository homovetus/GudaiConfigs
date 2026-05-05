-- Shared configuration
vim.g.mapleader = " "

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<CR>", "van", { remap = true, desc = "Init Treesitter selection" })
vim.keymap.set("x", "<CR>", "an", { remap = true, desc = "Increment Treesitter selection" })
vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Decrement Treesitter selection" })

if vim.g.vscode then
	-- VSCode Neovim configuration
	vim.pack.add({
		"https://github.com/folke/flash.nvim",
		"https://github.com/kylechui/nvim-surround",
		"https://github.com/shabaraba/ime-auto.nvim",
	})

	require("flash").setup({
		{
			labels = "arstdhneioqwfpgjluyzxcvbkm",
			label = { uppercase = false },
		},
	})

	vim.keymap.set("n", "<leader>f", "<cmd>lua require('vscode').call('editor.action.formatDocument')<cr>")
	vim.keymap.set("n", "<leader>t", "<cmd>lua require('vscode').call('workbench.view.explorer')<cr>")
	vim.keymap.set("n", "<leader>;", "<cmd>lua require('vscode').call('workbench.action.toggleAuxiliaryBar')<cr>")
	vim.keymap.set("n", "S", function() require("flash").treesitter() end)
	vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
	vim.keymap.set({ "x", "o" }, "r", function() require("flash").treesitter_search() end)
else
	-- Native Neovim configuration
	vim.opt.autoread = true
	vim.opt.relativenumber = true
	vim.opt.wrap = false

	vim.opt.expandtab = true
	vim.opt.shiftwidth = 4
	vim.opt.softtabstop = 4

	vim.opt.hlsearch = true
	vim.opt.incsearch = true

	vim.keymap.set("n", "gt", "<cmd>tabnext<cr>", { desc = "Next tab" })
	vim.keymap.set("n", "gT", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
end
