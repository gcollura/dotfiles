return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			options = { "buffers", "curdir" }, -- sessionoptions used for saving
		},
		keys = {
			{ "<leader>zs", "<cmd>lua require('persistence').load()<cr>" },
			{ "<leader>zc", "<cmd>lua require('persistence').load({ last = true })<cr>" },
			{ "<leader>zd", "<cmd>lua require('persistence').stop()<cr>" },
		},
	},
}
