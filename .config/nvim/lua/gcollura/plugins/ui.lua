---@type LazyPluginSpec[]
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "frappe",
			-- transparent_background = true,
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
			},
			default_integrations = true,
			integrations = {
				cmp = true,
				snacks = true,
				lsp_trouble = true,
				mason = true,
				fidget = true,
				telescope = {
					enabled = true,
				},
			},
		},
		-- config = function(_, opts)
		-- 	require("catppuccin").setup(opts)
		-- 	vim.cmd.colorscheme("catppuccin-frappe")
		-- 	for _, element in ipairs({ "FloatBorder", "NormalFloat", "Normal" }) do
		-- 		vim.api.nvim_set_hl(0, element, { bg = "none" })
		-- 	end
		-- end,
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = { ---@type snacks.plugins.Config
			lazygit = { enable = true },
			bufdelete = { enabled = true },
			quickfile = { enabled = true },
			bigfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = {
				enabled = true, -- enable/disable the plugin
				debounce = 200, -- time in ms to wait before updating
			},
			scroll = {
				enabled = false,
				animate = {
					duration = { step = 15, total = 125 },
					easing = "linear",
				},
			},
			notifier = {
				enabled = true,
				-- timeout = 5000,
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
				"<leader>zg",
				function()
					require("snacks").lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"gn",
				function()
					require("snacks").words.jump(1, true)
				end,
				mode = { "n", "v" },
				desc = "Jump to next word (LSP)",
			},
			{
				"gp",
				function()
					require("snacks").words.jump(-1, true)
				end,
				mode = { "n", "v" },
				desc = "Jump to previous word (LSP)",
			},
			-- 		{
			-- 			"<leader>gl",
			-- 			"<cmd>GitLink<cr>",
			-- 			mode = { "n", "v" },
			-- 			silent = true,
			-- 			noremap = true,
			-- 			desc = "Copy git permlink to clipboard",
			-- 		},
			-- 		{
			-- 			"<leader>gL",
			-- 			"<cmd>GitLink!<cr>",
			-- 			mode = { "n", "v" },
			-- 			silent = true,
			-- 			noremap = true,
			-- 			desc = "Open git permlink in browser",
			-- 		},
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
		"Bekaboo/dropbar.nvim",
		event = "BufReadPost",
		cond = vim.fn.has("nvim-0.10") == 1,
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
			keymaps = {
				["q"] = { "actions.close", mode = "n" },
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
		cond = vim.fn.has("nvim-0.10") == 1,
		opts = {
			-- options
		},
	},
	{
		"nvim-tree/nvim-web-devicons",
		opts = {
			override = {
				["graphqls"] = {
					icon = "",
					color = "#e535ab",
					cterm_color = "199",
					name = "GraphQL",
				},
			},
		},
	},
}
