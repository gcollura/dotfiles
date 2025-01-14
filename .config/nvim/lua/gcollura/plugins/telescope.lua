return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "graphite.nvim", dir = "~/personal/graphite.nvim" },
		},
		opts = {
			defaults = {
				prompt_prefix = "❯ ",
				selection_caret = "❯ ",
				file_ignore_patterns = {
					"./generated/.",
					"./node_modules/.",
					".git/.",
				},
				-- winblend = 15,
				mappings = {
					n = {
						["q"] = require("telescope.actions").close,
						["<c-t>"] = require("trouble.sources.telescope").open,
						["<c-q>"] = require("telescope.actions").smart_send_to_qflist
							+ require("telescope.actions").open_qflist,
						["<c-Q>"] = require("telescope.actions").smart_add_to_qflist
							+ require("telescope.actions").open_qflist,
						-- ["<c-c>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
					},
					i = {
						["<c-t>"] = require("trouble.sources.telescope").open,
						["<c-q>"] = require("telescope.actions").smart_send_to_qflist
							+ require("telescope.actions").open_qflist,
						["<c-Q>"] = require("telescope.actions").smart_add_to_qflist
							+ require("telescope.actions").open_qflist,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--hidden",
					"--smart-case",
					"--trim",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				lsp_references = {
					fname_width = 100,
					trim_text = true,
					layout_strategy = "vertical",
				},
				command_history = {
					theme = "ivy",
				},
				buffers = {
					layout_strategy = "vertical",
					layout_config = { width = { 0.35, min = 110 } },
					file_ignore_patterns = {},
					previewer = false,
					sort_lastused = true,
					sort_mru = true,
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
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		},
		keys = {
			{ "<leader>t", "<cmd>Telescope <cr>", mode = { "n", "v" }, desc = "Telescope" },
			{ "<leader>p", "<cmd>Telescope find_files<cr>", mode = { "n", "i", "v" }, desc = "Telescope find files" },
			{ "<leader>gg", "<cmd>Telescope live_grep<cr>", mode = { "n", "i", "v" }, desc = "Telescope live grep" },
			{ "<leader>P", "<cmd>Telescope commands<cr>", mode = { "n", "i", "v" }, desc = "Telescope commands" },
			{
				"<leader>c",
				"<cmd>Telescope command_history<cr>",
				mode = { "n", "i", "v" },
				desc = "Telescope command history",
			},
			{ "<leader>r", "<cmd>Telescope registers<cr>", mode = { "n", "v" }, desc = "Telescope registers" },
			{ "<leader>o", "<cmd>Telescope oldfiles<cr>", mode = { "n", "i", "v" }, desc = "Telescope old files" },
			{ "<leader>f", "<cmd>Telescope grep_string<cr>", mode = { "n", "i", "v" }, desc = "Telescope grep string" },
			{ "<leader>l", "<cmd>Telescope buffers<cr>", mode = { "n", "i", "v" }, desc = "Telescope buffers" },
			{
				"<c-r>",
				"<plug>(TelescopeFuzzyCommandSearch)",
				mode = { "c" },
				desc = "Telescope fuzzy command search",
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("graphite")
		end,
	},

	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ "<leader>u", "<cmd>Telescope undo<cr>", desc = "Telescope undo history" },
		},
		opts = {
			extensions = {
				undo = {
					use_delta = true,
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.8,
					},
				},
			},
		},
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")
		end,
	},
}
