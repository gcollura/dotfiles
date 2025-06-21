local function deprio(kind)
	return function(e1, e2)
		if e1:get_kind() == kind then
			return false
		end
		if e2:get_kind() == kind then
			return true
		end
	end
end

return {
	-- Language completion
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
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

			-- lsp_zero.extend_lspconfig({
			-- 	-- capabilities = require("cmp_nvim_lsp").default_capabilities(),
			-- 	capabilities = require("blink.cmp").get_lsp_capabilities(),
			-- 	lsp_attach = lsp_attach,
			-- })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = lsp_attach,
			})
			vim.lsp.config("*", {
				capabilities = require("blink-cmp").get_lsp_capabilities(),
			})

			local float_config = {
				border = "rounded",
				max_width = 100,
			}
			vim.diagnostic.config({
				float = float_config,
				update_in_insert = true,
				severity_sort = true,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				-- virtual_lines = {
				-- 	-- Only show virtual line diagnostics for the current cursor line
				-- 	current_line = false,
				-- },
				underline = true,
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
				automatic_installation = false,
				ensure_installed = { "ts_ls", "gopls", "graphql", "lua_ls" },
				automatic_enable = {
					exclude = {
						"rust_analyzer",
						"ts_ls",
					},
				},
			})

			vim.lsp.enable("vtsls")
			vim.lsp.config("vtsls", {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			})

			vim.lsp.enable("gopls")
			local gopls_cfg = vim.tbl_deep_extend("force", require("go.lsp").config() or {}, {
				settings = {
					gopls = {
						-- semanticTokens = false,
						analyses = {
							fieldalignment = false,
						},
						diagnosticsDelay = "3s",
						diagnosticsTrigger = "Edit",
					},
				},
			})
			-- root_dir callback is not compatible with vim.lsp.config
			gopls_cfg.root_dir = nil
			vim.lsp.config("gopls", gopls_cfg)

			vim.lsp.enable("eslint")
			vim.lsp.config("eslint", {
				-- on_attach = function(_, bufnr)
				-- 	vim.api.nvim_create_autocmd("BufWritePre", {
				-- 		buffer = bufnr,
				-- 		command = "EslintFixAll",
				-- 	})
				-- end,
			})

			vim.lsp.enable("graphql")
			vim.lsp.config("graphql", {
				flags = {
					debounce_text_changes = 150,
				},
				filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript" },
			})
		end,
	},
	{
		-- "hrsh7th/nvim-cmp",
		"iguanacucumber/magazine.nvim",
		enabled = false,
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
					"zbirenbaum/copilot.lua",
				},
				config = true,
			},
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			require("luasnip.loaders.from_vscode").lazy_load()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_types = require("cmp.types")
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
					{ name = "lazydev", priority = 80 },
					{ name = "nvim_lsp_signature_help", priority = 90 },
					{ name = "nvim_lsp", priority = 80 },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3, max_item_count = 15, priority = 0 },
					{ name = "nvim_lua", priority = 0 },
					{ name = "path", priority = 0 },
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sorting = {
					priority_weight = 4,
					comparators = {
						require("copilot_cmp.comparators").prioritize,

						deprio(cmp_types.lsp.CompletionItemKind.Snippet),
						deprio(cmp_types.lsp.CompletionItemKind.Text),
						deprio(cmp_types.lsp.CompletionItemKind.Keyword),
						-- Below is the default comparitor list and order for nvim-cmp
						cmp.config.compare.offset,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
						cmp.config.compare.locality,
						cmp.config.compare.length,
						cmp.config.compare.sort_text,
						cmp.config.compare.order,
					},
				},
				formatting = {
					expandable_indicator = true,
					fields = { "kind", "abbr", "menu" },
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
					["<C-y>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
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
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		dependencies = {
			{ "gonstoll/wezterm-types", lazy = true },
		},
		opts = {
			library = {
				"lazy.nvim",
				"nvim-treesitter",
				"blink.cmp",
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
