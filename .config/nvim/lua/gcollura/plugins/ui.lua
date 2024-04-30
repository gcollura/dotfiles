local function neotree_diff(state)
	local node = state.tree:get_node()
	local is_file = node.type == "file"
	if not is_file then
		vim.notify("Diff only for files", vim.log.levels.ERROR)
		return
	end
	-- open file
	local cc = require("neo-tree.sources.common.commands")
	cc.open(state, function()
		-- do nothing for dirs
	end)

	-- Fugitive
	vim.cmd([[Gdiffsplit]])
end

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
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				prompt_prefix = "❯ ",
				selection_caret = "❯ ",
				file_ignore_patterns = {
					"./generated/.",
					"./node_modules/.",
				},
				-- come up with a clever path display that doesn't hurt perf
				-- path_display = { "" },
				winblend = 15,
				mappings = {
					n = {
						["q"] = "close",
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
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
		},
	},
	{
		"Bekaboo/dropbar.nvim",
		cond = vim.fn.has("nvim-0.10"),
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
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
				"<cmd>Neotree left toggle<cr>",
				desc = "Neotree",
			},
		},
		opts = {
			source_selector = {
				winbar = false, -- toggle to show selector on winbar
				statusline = false, -- toggle to show selector on statusline
			},
			window = {
				mappings = {
					["gd"] = "show_diff",
				},
			},
			filesystem = {
				find_command = "fd",
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				commands = {
					show_diff = neotree_diff,
				},
			},
			git_status = {
				commands = {
					show_diff = neotree_diff,
				},
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
