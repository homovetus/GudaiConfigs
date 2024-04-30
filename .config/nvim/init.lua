vim.opt.autoread = true
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 4

-- search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true

vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_list_hide = [[^\(ntuser\|NTUSER\)\..*]]
vim.g.netrw_liststyle = 2
vim.g.netrw_winsize = -20

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- keymaps
vim.api.nvim_set_keymap("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "gH", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "gR", [[<cmd>lua vim.lsp.buf.rename()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "ga", [[<cmd>lua vim.lsp.buf.code_action()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "gh", [[<cmd>lua vim.lsp.buf.hover()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<cr>]], { noremap = true })
vim.api.nvim_set_keymap("n", "gr", [[<cmd>lua vim.lsp.buf.references()<cr>]], { noremap = true })

vim.api.nvim_set_keymap("t", "<esc><esc>", [[<c-\><c-n>]], { noremap = true })

-- functions
TermBoot = function()
	vim.cmd([[ToggleTerm]])
end

-- define vim command
vim.cmd([[command! TermBoot lua TermBoot()]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", { ui = { border = "rounded" } })
