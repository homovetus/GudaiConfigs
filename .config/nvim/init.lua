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

-- Shared configuration
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })

if vim.g.vscode then
	-- VSCode Neovim configuration
	vim.keymap.set("n", "<leader>f", "<cmd>lua require('vscode').call('editor.action.formatDocument')<cr>")
	vim.keymap.set("n", "<leader>t", "<cmd>lua require('vscode').call('workbench.view.explorer')<cr>")
	vim.keymap.set("n", "<leader>;", "<cmd>lua require('vscode').call('workbench.action.toggleAuxiliaryBar')<cr>")

	require("lazy").setup({
		spec = {
			{ import = "gui" },
		},
		checker = { enabled = true },
	})
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

	require("lazy").setup({
		spec = {
			{ import = "tui" },
		},
		checker = { enabled = true },
		dev = { path = "~/Sources" },
		install = { colorscheme = { "default" } },
		rocks = { enabled = false },
		ui = { border = "rounded" },
	})
end
