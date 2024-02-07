return {
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
}
