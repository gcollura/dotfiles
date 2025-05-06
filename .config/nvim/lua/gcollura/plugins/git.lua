return {
	"tpope/vim-fugitive",
	"sindrets/diffview.nvim",
	{
		"linrongbin16/gitlinker.nvim",
		config = true,
		keys = {
			{
				"<leader>gl",
				"<cmd>GitLink<cr>",
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
			current_line_blame_formatter = "    <author> • <author_time:%R> • <summary>",
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				-- do not attach the fugitive buffers
				if vim.startswith(vim.api.nvim_buf_get_name(bufnr), "fugitive://") then
					return false
				end

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
						gs.nav_hunk("next")
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.nav_hunk("prev")
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous hunk" })

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage selected hunk" })
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset selected hunk" })
				map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>gb", gs.blame_line, { desc = "Blame line" })
			end,
		},
	},
}
