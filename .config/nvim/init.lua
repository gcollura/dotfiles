vim.o.undofile = true
vim.o.autowriteall = true
vim.o.colorcolumn = "+1"
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5
vim.o.scrolloff = 4
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = "tab:▸ ,eol:¬"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.hidden = true

vim.o.pumblend = 15
vim.o.winblend = 15
vim.o.pumheight = 15

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250

vim.keymap.set("n", "<leader>w", ":w!<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-c>", ":nohls<CR><C-l>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>L", "<cmd>b #<cr>")
vim.keymap.set("n", "<s-tab>", "<c-o>", { noremap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

if vim.g.vscode then
	return
end

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.o.guifont = "JetBrainsMono Nerd Font:h12"
	vim.o.linespace = -1
	vim.g.neovide_theme = "dark"
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_input_macos_alt_is_meta = true
	vim.g.neovide_cursor_animation_length = 0.09
	vim.g.neovide_cursor_trail_size = 0.2

	vim.keymap.set("v", "<D-c>", '"+y', {}) -- Copy
	vim.keymap.set({ "n", "v" }, "<D-v>", '"+P', {}) -- Paste normal mode
	vim.keymap.set("c", "<D-v>", "<C-r>+", {}) -- Paste command mode
	vim.keymap.set("i", "<D-v>", "<C-r><C-p>*", { noremap = true }) -- Paste insert mode
	vim.keymap.set({ "n", "i" }, "<D-s>", "<cmd>w!<cr>", {})
end

local generalSettingsGroup = vim.api.nvim_create_augroup("ft settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "graphql", "json" },
	callback = function()
		vim.bo.expandtab = true
	end,
	group = generalSettingsGroup,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
	group = generalSettingsGroup,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive", "help", "qf", "guihua" },
	callback = function()
		vim.keymap.set("n", "q", ":q<CR>", { silent = true, buffer = true })
	end,
	group = generalSettingsGroup,
})

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

require("lazy").setup("gcollura.plugins", {
	change_detection = {
		enabled = true,
		notify = false,
	},
})

-- vim: fdm=marker et fen fdl=0 ts=2 sw=2 tw=80
