return {
	"folke/snacks.nvim",
	-- dir = "~/personal/snacks.nvim/",
	priority = 1000,
	lazy = false,
	opts = { ---@type snacks.Config
		picker = {
			layout = {
				preset = function()
					return vim.o.columns >= 120 and "telescope" or "buffers"
				end,
				reverse = true,
			},
			layouts = {
				select = {
					reverse = false,
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.4,
						border = "top",
						title = " {source} {live}",
						title_pos = "left",
						{ win = "input", height = 1, border = "bottom" },
						{
							box = "horizontal",
							{ win = "list", border = "none" },
							{ win = "preview", width = 0.6, border = "left" },
						},
					},
				},
				buffers = {
					preview = false,
					layout = {
						backdrop = false,
						width = 0.35,
						min_width = 110,
						height = 0.8,
						min_height = 30,
						box = "vertical",
						border = "rounded",
						title = "{source} {live}",
						title_pos = "center",
						{ win = "list", border = "none" },
						{ win = "input", height = 1, border = "top" },
					},
				},
			},
		},
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
		image = {
			enabled = true,
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
			"<leader>gz",
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
		{
			"<leader>t",
			function()
				Snacks.picker()
			end,
			mode = { "n", "v" },
			desc = "Pick picker",
		},
		{
			"<leader>p",
			function()
				Snacks.picker.smart({
					hidden = true,
				})
			end,
			mode = { "n", "i", "v" },
			desc = "Pick files",
		},
		{
			"<leader>gg",
			function()
				Snacks.picker.grep({
					hidden = true,
					follow = true,
				})
			end,
			mode = { "n", "i", "v" },
			desc = "Pick live grep",
		},
		{
			"<leader>C",
			function()
				Snacks.picker.commands({
					layout = {
						preset = "vscode",
					},
				})
			end,
			mode = { "n", "i", "v" },
			desc = "Telescope commands",
		},
		{
			"<leader>c",
			function()
				Snacks.picker.commands({
					name = "cmd",
					multi = { "command_history", "commands" },
					format = "command",
					matcher = {
						frecency = true, -- use frecency boosting
						sort_empty = true, -- sort even when the filter is empty
					},
					layout = {
						preset = "vscode",
					},
				})
			end,
			mode = { "n", "i", "v" },
			desc = "Pick command history",
		},
		{
			"<leader>r",
			function()
				Snacks.picker.registers()
			end,
			desc = "Pick registers",
		},
		{
			"<leader>o",
			function()
				Snacks.picker.recent()
			end,
			desc = "Pick old files",
		},
		{
			"<leader>f",
			function()
				Snacks.picker.grep_word({
					hidden = true,
					follow = true,
				})
			end,
			mode = { "n", "i", "v" },
			desc = "Pick grep string",
		},
		{
			"<leader>l",
			function()
				Snacks.picker.buffers({
					current = false,
					sort_lastused = true,
					layout = {
						preset = "buffers",
					},
				})
			end,
			mode = { "n", "i", "v" },
			desc = "Pick buffers",
		},
		{
			"<leader>u",
			function()
				Snacks.picker.undo()
			end,
			mode = { "n" },
			desc = "Pick undo history",
		},
	},
}
