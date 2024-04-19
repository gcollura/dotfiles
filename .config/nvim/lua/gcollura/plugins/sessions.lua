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
				"<cmd>lua require('persistence').load({ last = true })<cr>",
				desc = "Load last session",
			},
			{ "<leader>zd", "<cmd>lua require('persistence').stop()<cr>", desc = "Stop session persistence" },
		},
	},
}
