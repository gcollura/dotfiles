return {
	-- Language completion
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		branch = "v4.x",
		config = function()
			local lsp_zero = require("lsp-zero")

			local lsp_attach = function(_, bufnr)
				-- see :help lsp-zero-keybindings
				lsp_zero.default_keymaps({ buffer = bufnr })

				vim.keymap.set("n", "gr", "<cmd>Glance references<cr>", { buffer = bufnr, desc = "References" })
				vim.keymap.set(
					"n",
					"gi",
					"<cmd>Glance implementations<cr>",
					{ buffer = bufnr, desc = "Implementations" }
				)
				vim.keymap.set("n", "gd", "<cmd>Glance definitions<cr>", { buffer = bufnr, desc = "Definitions" })
				vim.keymap.set(
					"n",
					"go",
					"<cmd>Glance type_definitions<cr>",
					{ buffer = bufnr, desc = "Type Definitions" }
				)
				vim.keymap.set(
					"n",
					"<leader>.",
					"<cmd>lua vim.lsp.buf.code_action()<CR>",
					{ noremap = true, silent = true, buffer = bufnr, desc = "Code actions" }
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
			end

			lsp_zero.extend_lspconfig({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				lsp_attach = lsp_attach,
			})

			local float_config = {
				border = "rounded",
				max_width = 100,
			}
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)
			vim.diagnostic.config({
				float = float_config,
				update_in_insert = false,
				severity_sort = true,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "gopls", "graphql", "lua_ls" },
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
					ts_ls = function()
						-- require("lspconfig").ts_ls.setup({
						-- 	init_options = {
						-- 		preferences = {
						-- 			importModuleSpecifierPreference = "non-relative",
						-- 			importModuleSpecifierEnding = "minimal",
						-- 		},
						-- 	},
						-- })
					end,
					vtsls = function()
						require("lspconfig").vtsls.setup({})
					end,
					eslint = function()
						require("lspconfig").eslint.setup({
							on_attach = function(_, bufnr)
								vim.api.nvim_create_autocmd("BufWritePre", {
									buffer = bufnr,
									command = "EslintFixAll",
								})
							end,
						})
					end,
					gopls = function()
						local lsp_cfg = require("go.lsp").config()
						lsp_cfg = vim.tbl_deep_extend("force", lsp_cfg, {
							settings = {
								gopls = {
									analyses = {
										fieldalignment = false,
									},
								},
							},
						})
						require("lspconfig").gopls.setup(lsp_cfg)
					end,
					graphql = function()
						require("lspconfig").graphql.setup({
							flags = {
								debounce_text_changes = 150,
							},
							filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript" },
						})
					end,
					rust_analyzer = function()
						return true
					end,
				},
			})

			lsp_zero.setup()
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {
	-- 		settings = {
	-- 			typescript_file_preferences = {
	-- 				importModuleSpecifierPreference = "non-relative",
	-- 				importModuleSpecifierEnding = "minimal",
	-- 			},
	-- 		},
	-- 	},
	-- 	config = function(opts)
	-- 		local lsp_zero = require("lsp-zero")
	-- 		require("typescript-tools").setup(vim.tbl_extend("force", opts, {
	-- 			capatibilities = lsp_zero.get_capabilities(),
	-- 		}))
	-- 	end,
	-- },
	{
		-- "hrsh7th/nvim-cmp",
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
		dependencies = {
			{ "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
			{ "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
			{ "iguanacucumber/mag-buffer", name = "cmp-buffer" },
			{ "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
			-- "hrsh7th/cmp-nvim-lsp",
			-- "hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			-- "hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			-- "hrsh7th/cmp-cmdline",
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
							copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v20.14.0/bin/node", -- Node.js version must be > 18.x
						},
					},
				},
				config = true,
			},
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			require("luasnip.loaders.from_vscode").lazy_load()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local lsp_zero = require("lsp-zero")
			local cmp_action = lsp_zero.cmp_action()
			local cmp_format = lsp_zero.cmp_format({
				details = true,
			})

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
					{ name = "buffer", keyword_length = 3, max_item_count = 15 },
					{ name = "nvim_lua" },
				}, {
					{ name = "path" },
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
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
			highlight = {
				enable = true,
				disable = function(_, bufnr) -- Disable in large buffers
					return vim.api.nvim_buf_line_count(bufnr) > 50000
				end,
			},
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
				"graphql",
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
		-- TODO change this back when https://github.com/nvim-treesitter/nvim-treesitter-context/issues/509 is fixed
		commit = "7f7eeaa99e5a9beab518f502292871ae5f20de6f",
		opts = { mode = "cursor", max_lines = 5 },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Trouble",
		opts = {
			focus = true,
		},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle filter = { severity=vim.diagnostic.severity.ERROR }<cr>",
				mode = { "n" },
				desc = "Trouble toggle",
			},
			{
				"<leader>xw",
				"<cmd>Trouble toggle workspace_diagnostics<cr>",
				mode = { "n" },
				desc = "Trouble workspace diagnostics",
			},
			{
				"<leader>xd",
				"<cmd>Trouble toggle document_diagnostics<cr>",
				mode = { "n" },
				desc = "Trouble document diagnostics",
			},
			{ "<leader>xq", "<cmd>Trouble toggle qflist<cr>", mode = { "n" }, desc = "Trouble quickfix" },
			{ "<leader>xl", "<cmd>Trouble loclist<cr>", mode = { "n" }, desc = "Trouble location list" },
			{ "gR", "<cmd>Trouble lsp_references<cr>", mode = { "n" }, desc = "Trouble lsp references" },
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
		lazy = false,
		config = function(_, opts)
			opts.pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
			require("Comment").setup(opts)
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
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
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-dap",
		},
		build = ':lua require("go.install").update_all_sync()',
		opts = {
			trouble = true,
			luasnip = false,
			dap_debug_keymap = false,
			dap_enrich_config = require("gcollura.dap.enrich_config").enrich_config,
			lsp_cfg = false,
			run_in_floaterm = true,
			lsp_codelens = false,
			lsp_keymaps = false,
			floaterm = { -- position
				posititon = "right", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
				width = 0.45, -- width of float window if not auto
				height = 0.85, -- height of float window if not auto
				title_colors = "nord", -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
				-- can also set to a list of colors to define colors to choose from
				-- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
			},
			lsp_inlay_hints = {
				enable = true,
				-- hint style, set to 'eol' for end-of-line hints, 'inlay' for inline hints
				-- inlay only avalible for 0.10.x
				style = "eol",
			},
			verbose = false,
			log_path = vim.fn.stdpath("cache") .. "/go.nvim.log",
			-- don't let go.nvim mess with global vim.diagnostics
			diagnostic = false,
		},
		keys = {
			{
				"<leader>dt",
				"<cmd>GoDebug -t<CR>",
				desc = "Go: Start debug session for go test file",
			},
			{
				"<leader>dT",
				"<cmd>GoDebug -n<CR>",
				desc = "Go: Start debug session for nearest go test function",
			},
		},
	},
	{
		"jparise/vim-graphql",
		init = function()
			vim.g.graphql_javascript_tags = { "gql", "graphql", "Relay.QL" }
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "typescriptreact" },
		config = true,
	},
	-- mjml email templating
	"amadeus/vim-mjml",
	{
		-- handle line and column numbers in file names
		"wsdjeg/vim-fetch",
	},

	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {},
	},
}
