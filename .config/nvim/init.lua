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

local generalSettingsGroup = vim.api.nvim_create_augroup("ft settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "graphql", "json" },
	callback = function()
		vim.bo.expandtab = true
	end,
	group = generalSettingsGroup,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive", "help", "qf" },
	callback = function()
		vim.keymap.set("n", "q", ":q<CR>", { silent = true, buffer = true })
	end,
	group = generalSettingsGroup,
})

if vim.g.vscode then
	require("lazy").setup({
		{
			"echasnovski/mini.ai",
			version = "*",
		},
	})
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

require("lazy").setup({
	-- UI
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("onedark")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "onedark",
				disabled_filetypes = {
					statusline = { "neo-tree" },
					winbar = {},
				},
			},
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = " ●", -- Text to show when the buffer is modified
						},
					},
				},
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				prompt_prefix = "❯ ",
				selection_caret = "❯ ",
				file_ignore_patterns = {
					"./generated/.",
					"./node_modules/.",
				},
				winblend = 15,
				mappings = {
					n = {
						["q"] = "close",
					},
				},
			},
			pickers = {
				buffers = {
					sort_lastused = true,
					mappings = {
						n = {
							["dd"] = "delete_buffer",
						},
						i = {
							["<c-d>"] = "delete_buffer",
						},
					},
				},
			},
		},
		keys = {
			{ "<leader>t", "<cmd>Telescope <cr>", mode = { "n", "i", "v" } },
			{ "<leader>p", "<cmd>Telescope find_files<cr>", mode = { "n", "i", "v" } },
			{ "<leader>g", "<cmd>Telescope live_grep<cr>", mode = { "n", "i", "v" } },
			{ "<leader>P", "<cmd>Telescope commands<cr>", mode = { "n", "i", "v" } },
			{ "<leader>r", "<cmd>Telescope registers<cr>", mode = { "n", "i", "v" } },
			{ "<leader>o", "<cmd>Telescope oldfiles<cr>", mode = { "n", "i", "v" } },
			{ "<leader>f", "<cmd>Telescope grep_string<cr>", mode = { "n", "i", "v" } },
			{ "<leader>l", "<cmd>Telescope buffers<cr>", mode = { "n", "i", "v" } },
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<leader>s",
				"<cmd>Neotree<cr>",
			},
		},
		opts = {
			source_selector = {
				winbar = false, -- toggle to show selector on winbar
				statusline = false, -- toggle to show selector on statusline
			},
			filesystem = {
				find_command = "fd",
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
			},
			group_empty_dirs = true,
		},
	},

	-- Language completion
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		branch = "v3.x",
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(_, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })

				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>.",
					"<cmd>lua vim.lsp.buf.code_action()<CR>",
					{ noremap = true, silent = true, buffer = bufnr }
				)
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						vim.diagnostic.open_float(nil, {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = "rounded",
							source = "always",
							prefix = " ",
							scope = "cursor",
							max_width = 100,
						})
					end,
				})
			end)

			lsp_zero.set_sign_icons({
				error = "✘",
				warn = "▲",
				hint = "⚑",
				info = "»",
			})

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "tsserver", "gopls", "graphql", "lua_ls" },
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
					tsserver = function()
						require("lspconfig").tsserver.setup({
							init_options = {
								preferences = {
									importModuleSpecifierPreference = "non-relative",
									importModuleSpecifierEnding = "minimal",
								},
							},
							on_attach = function(client, bufnr)
								print("hello tsserver")
							end,
						})
					end,
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-cmdline",
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()
			require("luasnip.loaders.from_vscode").lazy_load()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()
			local cmp_format = lsp_zero.cmp_format()
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			local cmp_kinds = {
				Text = " ",
				Method = " ",
				Function = " ",
				Constructor = " ",
				Field = " ",
				Variable = " ",
				Class = " ",
				Interface = " ",
				Module = " ",
				Property = " ",
				Unit = " ",
				Value = " ",
				Enum = " ",
				Keyword = " ",
				Snippet = " ",
				Color = " ",
				File = " ",
				Reference = " ",
				Folder = " ",
				EnumMember = " ",
				Constant = " ",
				Struct = " ",
				Event = " ",
				Operator = " ",
				TypeParameter = " ",
				Copilot = " ",
			}

			cmp.setup({
				sources = cmp.config.sources({
					{ name = "copilot", priority = 100 },
					{ name = "nvim_lsp", priority = 90 },
					{ name = "luasnip", keyword_length = 2 },
				}, {
					{ name = "buffer", keyword_length = 3 },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua", group_index = 4 },
				}, {
					{ name = "path", group_index = 4 },
				}),
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						vim_item = cmp_format.format(entry, vim_item)
						vim_item.kind = cmp_kinds[vim_item.kind] or vim_item.kind
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-k>"] = cmp_action.luasnip_jump_forward(),
					["<C-l>"] = cmp_action.luasnip_jump_backward(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-s>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "copilot" },
							},
						},
					}),
					["<C-y>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<C-h>"] = function()
						vim.lsp.buf.signature_help()
					end,
				}),
				preselect = cmp.PreselectMode.Item,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
			})
			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!", "GoTest" },
						},
					},
				}),
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				opts = {
					suggestion = {
						enabled = false,
						auto_trigger = false,
						debounce = 75,
					},
				},
			},
		},
		config = true,
		-- config = function(_, opts)
		-- 	local copilot_cmp = require("copilot_cmp")
		-- 	copilot_cmp.setup(opts)
		-- 	-- attach cmp source whenever copilot attaches
		-- 	-- fixes lazy-loading issues with the copilot cmp source
		-- 	vim.api.nvim_create_autocmd("LspAttach", {
		-- 		callback = function(args)
		-- 			local client = vim.lsp.get_client_by_id(args.data.client_id)
		--
		-- 			if client.name == "copilot" then
		-- 				copilot_cmp._on_insert_enter({})
		-- 			end
		-- 		end,
		-- 	})
		-- end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
	},

	-- Editing
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier", "eslint" },
				typescriptreact = { "prettier", "eslint" },
				graphql = { "prettier", "eslint" },
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.2",
		build = ":TSUpdate",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"diff",
				"go",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			disable = function(_, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)
			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "nvim_treesitter#foldexpr()"
			vim.o.foldenable = false
		end,
	},
	-- Show context of the current function
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { mode = "cursor", max_lines = 5 },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "TroubleToggle",
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>", mode = { "n" } },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", mode = { "n" } },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", mode = { "n" } },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", mode = { "n" } },
			{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>", mode = { "n" } },
			{ "gR", "<cmd>TroubleToggle lsp_references<cr>", mode = { "n" } },
		},
	},

	-- Extend and create a/i textobjects
	{
		"echasnovski/mini.ai",
		version = "*",
		opts = {
			n_lines = 500,
			custom_textobjects = {
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"numToStr/Comment.nvim",
		-- without opts the plugin won't load
		opts = {},
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				opts = {
					enable_autocmd = false,
				},
			},
		},
	},

	-- Automatically add closing tags for HTML and JSX
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_filetype = { "TelescopePrompt", "vim" },
		},
	},

	-- Languages
	{
		"ray-x/go.nvim",
		lazy = true,
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
		opts = {
			trouble = true,
			luasnip = true,
		},
		-- config = function(_, opts)
		-- 	require("go").setup(opts)
		-- 	vim.api.nvim_create_user_command("GoTestCurrentFunc", function()
		-- 		vim.cmd("GoTest -nF")
		-- 	end, { nargs = 1 })
		-- end,
	},
	{
		"jparise/vim-graphql",
		ft = "graphql",
	},

	{
		"mbbill/undotree",
		cmd = { "UndoTree" },
		keys = {
			{
				"<leader>u",
				vim.cmd.UndotreeToggle,
			},
		},
	},
	{
		"famiu/bufdelete.nvim",
		cmd = { "Bdelete", "Bwipeout" },
		keys = {
			{
				"<leader>q",
				vim.cmd.Bdelete,
			},
		},
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				filetypes_denylist = {
					"dirbuf",
					"dirvish",
					"fugitive",
					"neo-tree",
					"TelescopePrompt",
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>G", "<cmd>Git<cr>" },
		},
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = { "GitLink" },
		keys = {
			{
				"<leader>gl",
				vim.cmd.GitLink,
				mode = { "n", "v" },
				silent = true,
				noremap = true,
				desc = "Copy git permlink to clipboard",
			},
			{
				"<leader>gL",
				"<cmd>GitLink!<cr>",
				mode = { "n", "v" },
				silent = true,
				noremap = true,
				desc = "Open git permlink in browser",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			current_line_blame_formatter = "   <author> • <author_time:%R> • <summary>",
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 3000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk)
				map("n", "<leader>gr", gs.reset_hunk)
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
			end,
		},
	},
})

-- vim: fdm=marker et fen fdl=0 ts=2 sw=2 tw=80
