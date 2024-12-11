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

				if vim.version().minor < 11 then
					-- remove once 0.11 is out
					vim.keymap.set("n", "grn", function()
						vim.lsp.buf.rename()
					end, { desc = "vim.lsp.buf.rename()" })

					vim.keymap.set({ "n", "x" }, "gra", function()
						vim.lsp.buf.code_action()
					end, { desc = "vim.lsp.buf.code_action()" })

					vim.keymap.set("n", "grr", function()
						vim.lsp.buf.references()
					end, { desc = "vim.lsp.buf.references()" })

					vim.keymap.set("n", "gri", function()
						vim.lsp.buf.implementation()
					end, { desc = "vim.lsp.buf.implementation()" })

					vim.keymap.set("n", "gO", function()
						vim.lsp.buf.document_symbol()
					end, { desc = "vim.lsp.buf.document_symbol()" })

					vim.keymap.set({ "i", "s" }, "<C-S>", function()
						vim.lsp.buf.signature_help()
					end, { desc = "vim.lsp.buf.signature_help()" })
				end
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
						---@type table
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
					{ name = "nvim_lsp_signature_help", priority = 90 },
					{ name = "nvim_lsp", priority = 80 },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3, max_item_count = 15, priority = 0 },
					{ name = "nvim_lua" },
					{ name = "path" },
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sorting = {
					priority_weight = 2,
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
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {},
	},
}
