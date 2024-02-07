return {
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>G", "<cmd>Git<cr>" },
		},
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = { "GitLink" },
		keys = {
			{
				"<leader>gl",
				vim.cmd.GitLink,
				mode = { "n", "v" },
				silent = true,
				noremap = true,
				desc = "Copy git permlink to clipboard",
			},
			{
				"<leader>gL",
				"<cmd>GitLink!<cr>",
				mode = { "n", "v" },
				silent = true,
				noremap = true,
				desc = "Open git permlink in browser",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			current_line_blame_formatter = "   <author> • <author_time:%R> • <summary>",
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 3000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk)
				map("n", "<leader>gr", gs.reset_hunk)
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
			end,
		},
	},
}
