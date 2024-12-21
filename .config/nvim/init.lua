vim.o.autoread = true
vim.o.clipboard = "unnamedplus"
vim.o.relativenumber = true
vim.o.relativenumber = true
vim.o.updatetime = 500
vim.o.wrap = false

vim.o.expandtab = true
vim.o.smartindent = true

-- search
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_list_hide = [[^\(ntuser\|NTUSER\)\..*]]
vim.g.netrw_liststyle = 2
vim.g.netrw_winsize = -20

-- keymaps
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { noremap = true })
vim.keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { noremap = true })
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { noremap = true })
vim.keymap.set("n", "<s-tab>", "<cmd>bprevious<cr>", { noremap = true })
vim.keymap.set("n", "<leader>bd", "<cmd>bn|bd#<cr>", { noremap = true })

-- functions
TermBoot = function()
	vim.cmd([[ToggleTerm]])
end

-- define vim command
vim.cmd([[command! TermBoot lua TermBoot()]])

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
	dev = { path = "~/Sources" },
	rocks = { enabled = false },
	ui = { border = "rounded" },
})
