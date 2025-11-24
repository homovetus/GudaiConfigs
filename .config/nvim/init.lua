local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { noremap = true })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { noremap = true })

if vim.g.vscode then
	vim.keymap.set("n",
		"<leader>f",
		"<cmd>lua require('vscode').call('editor.action.formatDocument')<cr>",
		{ noremap = true })
	require("lazy").setup({
		spec = {
			{ import = "gui" },
		},
		checker = { enabled = true },
	})
else
	vim.o.autoread = true
	vim.o.wrap = false

	vim.o.hlsearch = true
	vim.o.incsearch = true

	vim.o.expandtab = true
	vim.o.shiftwidth = 4
	vim.o.softtabstop = 4

	vim.o.relativenumber = true

	require("lazy").setup({
		spec = {
			{ import = "tui" },
		},
		dev = { path = "~/Sources" },
		rocks = { enabled = false },
		ui = { border = "rounded" },
		install = { colorscheme = { "default" } },
		checker = { enabled = true },
	})
end
