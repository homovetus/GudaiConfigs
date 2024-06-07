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

-- keymaps
vim.keymap.set("n", "<c-t>", [[<cmd>tabnext<cr>]], { noremap = true })
vim.keymap.set("n", "<c-s-t>", [[<cmd>tabprevious<cr>]], { noremap = true })
vim.keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { noremap = true })

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
require("lazy").setup("plugins", { ui = { border = "rounded" }, dev = { path = "~/Sources" } })
