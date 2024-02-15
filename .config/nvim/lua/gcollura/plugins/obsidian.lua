local personal_vault = vim.fn.expand("~") .. "/OneDrive/Obsidian/personal"

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		"BufReadPre "
			.. personal_vault
			.. "/*",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = personal_vault,
			},
		},
		daily_notes = {
			folder = "daily",
		},
		completion = {
			nvim_cmp = true,
		},
		picker = {
			name = "telescope.nvim",
			mappings = {
				new = "<C-x>", -- Create a new note from your query.
				insert_link = "<C-l>", -- Insert a link to the selected note.
			},
		},
	},
}
