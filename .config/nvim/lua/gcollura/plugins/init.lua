return {
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
			local float_config = {
				border = "rounded",
				max_width = 100,
			}
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)
			vim.diagnostic.config({ float = float_config })

			lsp_zero.on_attach(function(_, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })

				vim.keymap.set("n", "gr", "<cmd>Glance references<cr>", { buffer = bufnr })
				vim.keymap.set("n", "gi", "<cmd>Glance implementations<cr>", { buffer = bufnr })
				vim.keymap.set("n", "gd", "<cmd>Glance definitions<cr>", { buffer = bufnr })
				vim.keymap.set("n", "go", "<cmd>Glance type_definitions<cr>", { buffer = bufnr })
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
							source = "always",
							prefix = " ",
							scope = "cursor",
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
						})
					end,
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
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
			},
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
					{ name = "nvim_lsp_signature_help", priority = 90 },
					{ name = "nvim_lsp", priority = 80 },
				}, {
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
					{ name = "nvim_lua" },
				}, {
					{ name = "path" },
				}),
				formatting = {
					expandable_indicator = true,
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						vim_item = cmp_format.format(entry, vim_item)
						if entry.source.name == "nvim_lsp_signature_help" then
							vim_item.menu = "[lsp sig]"
						end
						vim_item.kind = cmp_kinds[vim_item.kind] or vim_item.kind
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
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
				preselect = cmp.PreselectMode.None,
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

	-- Editing
	{
		"nvim-treesitter/nvim-treesitter",
		-- tag = "v0.9.2",
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
		event = { "BufReadPre", "BufNewFile" },
		config = true,
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
			run_in_floaterm = true,
		},
	},
	{
		"jparise/vim-graphql",
		ft = "graphql",
		init = false,
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
		"wsdjeg/vim-fetch",
	},
	{ "folke/neodev.nvim", opts = {} },
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "typescriptreact" },
	},
}
