vim.opt.undofile = true
vim.opt.autowriteall = true
vim.opt.colorcolumn = "+1"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 5
vim.opt.scrolloff = 4
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·", extends = ">", precedes = "<" }
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.hidden = true
vim.opt.inccommand = "split"

vim.opt.guicursor =
	[[n-v-c:block,i-ci-ve:ver35,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff150-blinkon450-Cursor/lCursor,sm:block-blinkwait300-blinkoff150-blinkon300]]

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.pumblend = 15
vim.opt.winblend = 15
vim.opt.pumheight = 15

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250

vim.keymap.set("n", "<leader>w", ":w!<CR>", { silent = true })
vim.keymap.set("n", "<leader>W", ":!mkdir -p %:h<CR> :w!<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-c>", ":nohls<CR><C-l>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>L", "<cmd>b #<cr>")
vim.keymap.set("n", "<s-tab>", "<c-o>", { noremap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

if vim.g.vscode then
	return
end

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
	vim.opt.linespace = -1
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
	pattern = { "typescript", "typescriptreact", "graphql", "json", "proto", "javascript" },
	callback = function()
		vim.bo.expandtab = true
	end,
	group = generalSettingsGroup,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go" },
	callback = function()
		vim.opt_local.textwidth = 100
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
