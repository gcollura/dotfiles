return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			options = { "buffers", "curdir" }, -- sessionoptions used for saving
		},
		keys = {
			{
				"<leader>zc",
				"<cmd>lua require('persistence').load()<cr>",
				desc = "Load session for current directory",
			},
			{
				"<leader>zs",
				"<cmd>lua require('persistence').save()<cr>",
				desc = "Save current session",
			},
			{ "<leader>zd", "<cmd>lua require('persistence').stop()<cr>", desc = "Stop session persistence" },
		},
		config = function(_, opts)
			require("persistence").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("disable_session_persistence", { clear = true }),
				pattern = { "gitcommit" },
				callback = function()
					require("persistence").stop()
				end,
			})
		end,
	},
}
