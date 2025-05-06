return {
	-- Editing
	{ ---@type LazyPlugin
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			highlight = {
				enable = true,
				disable = function(_, bufnr) -- Disable in large buffers
					return vim.api.nvim_buf_line_count(bufnr) > 50000
				end,
			},
			indent = { enable = true },
			incremental_selection = { enable = true },
			textobjects = { enable = true },
			disable = function(_, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
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
	{ ---@type LazyPlugin
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
		-- dir = "~/personal/go.nvim",
		-- enabled = false,
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
				posititon = "auto", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
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
			vim.g.graphql_javascript_tags = { "gql", "graphql", "Relay.QL", "# @genqlient" }
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
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
}
