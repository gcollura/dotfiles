return {
	{ ---@type LazyPlugin
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
				go = true,
			},
		},
	},
}
