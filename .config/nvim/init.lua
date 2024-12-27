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
vim.opt.signcolumn = "yes"

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

--- Execute a command and print errors without a stacktrace.
--- @param opts table Arguments to |nvim_cmd()|
local function cmd(opts)
	local _, err = pcall(vim.api.nvim_cmd, opts, {})
	if err then
		vim.api.nvim_err_writeln(err:sub(#"Vim:" + 1))
	end
end

if vim.version().minor >= 11 then
	vim.notify("Vim version is 11 or greater")
end

vim.keymap.set("n", "]]", function()
	local t = require("nvim-treesitter.ts_utils")
	local node = t.get_node_at_cursor()
	if node == nil then
		return
	end
	t.goto_node(t.get_next_node(node, true, true), false, true)
end)

vim.keymap.set("n", "[[", function()
	local t = require("nvim-treesitter.ts_utils")
	local node = t.get_node_at_cursor()
	if node == nil then
		return
	end
	t.goto_node(t.get_previous_node(node, true, true), false, true)
end)

if vim.version().minor < 11 then
	-- Quickfix mappings
	vim.keymap.set("n", "[q", function()
		cmd({ cmd = "cprevious", count = vim.v.count1 })
	end, { desc = ":cprevious" })

	vim.keymap.set("n", "]q", function()
		cmd({ cmd = "cnext", count = vim.v.count1 })
	end, { desc = ":cnext" })

	vim.keymap.set("n", "[Q", function()
		cmd({ cmd = "crewind", count = vim.v.count ~= 0 and vim.v.count or nil })
	end, { desc = ":crewind" })

	vim.keymap.set("n", "]Q", function()
		cmd({ cmd = "clast", count = vim.v.count ~= 0 and vim.v.count or nil })
	end, { desc = ":clast" })

	vim.keymap.set("n", "[<C-Q>", function()
		cmd({ cmd = "cpfile", count = vim.v.count1 })
	end, { desc = ":cpfile" })

	vim.keymap.set("n", "]<C-Q>", function()
		cmd({ cmd = "cnfile", count = vim.v.count1 })
	end, { desc = ":cnfile" })

	-- Location list mappings
	vim.keymap.set("n", "[l", function()
		cmd({ cmd = "lprevious", count = vim.v.count1 })
	end, { desc = ":lprevious" })

	vim.keymap.set("n", "]l", function()
		cmd({ cmd = "lnext", count = vim.v.count1 })
	end, { desc = ":lnext" })

	vim.keymap.set("n", "[L", function()
		cmd({ cmd = "lrewind", count = vim.v.count ~= 0 and vim.v.count or nil })
	end, { desc = ":lrewind" })

	vim.keymap.set("n", "]L", function()
		cmd({ cmd = "llast", count = vim.v.count ~= 0 and vim.v.count or nil })
	end, { desc = ":llast" })

	vim.keymap.set("n", "[<C-L>", function()
		cmd({ cmd = "lpfile", count = vim.v.count1 })
	end, { desc = ":lpfile" })

	vim.keymap.set("n", "]<C-L>", function()
		cmd({ cmd = "lnfile", count = vim.v.count1 })
	end, { desc = ":lnfile" })

	-- Argument list
	vim.keymap.set("n", "[a", function()
		cmd({ cmd = "previous", count = vim.v.count1 })
	end, { desc = ":previous" })

	vim.keymap.set("n", "]a", function()
		-- count doesn't work with :next, must use range. See #30641.
		cmd({ cmd = "next", range = { vim.v.count1 } })
	end, { desc = ":next" })

	vim.keymap.set("n", "[A", function()
		if vim.v.count ~= 0 then
			cmd({ cmd = "argument", count = vim.v.count })
		else
			cmd({ cmd = "rewind" })
		end
	end, { desc = ":rewind" })

	vim.keymap.set("n", "]A", function()
		if vim.v.count ~= 0 then
			cmd({ cmd = "argument", count = vim.v.count })
		else
			cmd({ cmd = "last" })
		end
	end, { desc = ":last" })

	-- Tags
	vim.keymap.set("n", "[t", function()
		-- count doesn't work with :tprevious, must use range. See #30641.
		cmd({ cmd = "tprevious", range = { vim.v.count1 } })
	end, { desc = ":tprevious" })

	vim.keymap.set("n", "]t", function()
		-- count doesn't work with :tnext, must use range. See #30641.
		cmd({ cmd = "tnext", range = { vim.v.count1 } })
	end, { desc = ":tnext" })

	vim.keymap.set("n", "[T", function()
		-- count doesn't work with :trewind, must use range. See #30641.
		cmd({ cmd = "trewind", range = vim.v.count ~= 0 and { vim.v.count } or nil })
	end, { desc = ":trewind" })

	vim.keymap.set("n", "]T", function()
		-- :tlast does not accept a count, so use :trewind if count given
		if vim.v.count ~= 0 then
			cmd({ cmd = "trewind", range = { vim.v.count } })
		else
			cmd({ cmd = "tlast" })
		end
	end, { desc = ":tlast" })

	vim.keymap.set("n", "[<C-T>", function()
		-- count doesn't work with :ptprevious, must use range. See #30641.
		cmd({ cmd = "ptprevious", range = { vim.v.count1 } })
	end, { desc = " :ptprevious" })

	vim.keymap.set("n", "]<C-T>", function()
		-- count doesn't work with :ptnext, must use range. See #30641.
		cmd({ cmd = "ptnext", range = { vim.v.count1 } })
	end, { desc = ":ptnext" })

	-- Buffers
	vim.keymap.set("n", "[b", function()
		cmd({ cmd = "bprevious", count = vim.v.count1 })
	end, { desc = ":bprevious" })

	vim.keymap.set("n", "]b", function()
		cmd({ cmd = "bnext", count = vim.v.count1 })
	end, { desc = ":bnext" })

	vim.keymap.set("n", "[B", function()
		if vim.v.count ~= 0 then
			cmd({ cmd = "buffer", count = vim.v.count })
		else
			cmd({ cmd = "brewind" })
		end
	end, { desc = ":brewind" })

	vim.keymap.set("n", "]B", function()
		if vim.v.count ~= 0 then
			cmd({ cmd = "buffer", count = vim.v.count })
		else
			cmd({ cmd = "blast" })
		end
	end, { desc = ":blast" })

	-- Add empty lines
	vim.keymap.set("n", "[<Space>", function()
		-- TODO: update once it is possible to assign a Lua function to options #25672
		vim.go.operatorfunc = "v:lua.require'vim._buf'.space_above"
		return "g@l"
	end, { expr = true, desc = "Add empty line above cursor" })

	vim.keymap.set("n", "]<Space>", function()
		-- TODO: update once it is possible to assign a Lua function to options #25672
		vim.go.operatorfunc = "v:lua.require'vim._buf'.space_below"
		return "g@l"
	end, { expr = true, desc = "Add empty line below cursor" })
end

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
	change_detection = { ---@type LazyConfig
		enabled = true,
		notify = false,
	},
})

-- vim: fdm=marker et fen fdl=0 ts=2 sw=2 tw=80
