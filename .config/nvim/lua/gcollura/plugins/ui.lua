return {
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("onedark")
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = {
			dim_inactive_windows = true,
			variant = "auto",
		},
		init = function()
			-- vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "frappe",
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
			},
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			notifier = {
				enabled = true,
				timeout = 3000,
				style = "minimal",
			},
		},
		keys = {
			{
				"<leader>q",
				function()
					require("snacks").bufdelete()
				end,
				desc = "Delete current buffer",
			},
			{
				"<leader>z",
				function()
					require("snacks").lazygit()
				end,
				desc = "Lazygit",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				-- theme = "onedark",
				theme = "catppuccin",
				globalstatus = true,
				ignore_focus = {
					"lspinfo",
				},
			},
			extensions = {
				"fugitive",
				"quickfix",
				"neo-tree",
				"mason",
				"lazy",
				"trouble",
			},
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1, -- show relative path
						symbols = {
							modified = " ●", -- Text to show when the buffer is modified
						},
					},
				},
			},
		},
	},
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		opts = {
			use_trouble_qf = true,
			hooks = {
				before_open = function(results, open, jump, _)
					if #results == 1 then
						jump(results[1]) -- argument is optional
					else
						open(results) -- argument is optional
					end
				end,
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
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
				winblend = 15,
				mappings = {
					n = {
						["q"] = require("telescope.actions").close,
						["<c-t>"] = require("trouble.sources.telescope").open,
					},
					i = { ["<c-t>"] = require("trouble.sources.telescope").open },
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
				buffers = {
					layout_strategy = "vertical",
					layout_config = { width = { 0.35, min = 110 } },
					-- theme = "dropdown",
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
			{ "<leader>t", "<cmd>Telescope <cr>", mode = { "n", "i", "v" }, desc = "Telescope" },
			{ "<leader>p", "<cmd>Telescope find_files<cr>", mode = { "n", "i", "v" }, desc = "Telescope find files" },
			{ "<leader>gg", "<cmd>Telescope live_grep<cr>", mode = { "n", "i", "v" }, desc = "Telescope live grep" },
			{ "<leader>P", "<cmd>Telescope commands<cr>", mode = { "n", "i", "v" }, desc = "Telescope commands" },
			{
				"<leader>c",
				"<cmd>Telescope command_history<cr>",
				mode = { "n", "i", "v" },
				desc = "Telescope command history",
			},
			{ "<leader>r", "<cmd>Telescope registers<cr>", mode = { "n", "i", "v" }, desc = "Telescope registers" },
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
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "BufReadPost",
		cond = vim.fn.has("nvim-0.10"),
		opts = {
			bar = {
				pick = {
					pivots = "asdfghjkl;'zxcvbnm,./",
				},
			},
			menu = {
				keymaps = {
					["h"] = function()
						local utils = require("dropbar.utils")
						local menu = utils.menu.get_current()
						if not menu then
							return
						end
						if menu.prev_menu then
							menu:close()
						else
							local bar = require("dropbar.utils.bar").get({ win = menu.prev_win })
							local bar_components = bar and bar.components[1]._.bar.components or {}
							for _, component in ipairs(bar_components) do
								if component.menu then
									local idx = component._.bar_idx
									menu:close()
									require("dropbar.api").pick(idx - 1)
								end
							end
						end
					end,
					["l"] = function()
						local utils = require("dropbar.utils")
						local menu = utils.menu.get_current()
						if not menu then
							return
						end
						local cursor = vim.api.nvim_win_get_cursor(menu.win)
						local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
				},
			},
		},
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		keys = {
			{
				"<leader>S",
				function()
					require("dropbar.api").pick()
				end,
				desc = "Dropbar",
			},
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			float = {
				-- Padding around the floating window
				max_width = 180,
				border = "rounded",
				win_options = {
					winblend = 15,
				},
			},
		},
		keys = {
			{
				"<leader>s",
				"<cmd>Oil --float<cr>",
				desc = "Open directory in Oil",
			},
		},
	},
	{
		"mbbill/undotree",
		cmd = { "UndoTree" },
		keys = {
			{
				"<leader>u",
				vim.cmd.UndotreeToggle,
				desc = "Toggle Undotree",
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
		"j-hui/fidget.nvim",
		cond = vim.fn.has("nvim-0.10"),
		opts = {
			-- options
		},
	},
}
