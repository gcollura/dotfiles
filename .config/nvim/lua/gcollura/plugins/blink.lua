return {
	{ ---@type LazyPlugin
		"saghen/blink.cmp",
		enabled = true,
		lazy = false,
		dependencies = {
			"fang2hou/blink-copilot",
		},
		version = "v1.*",
		build = "cargo build --release",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
				preset = "default",
				["<C-k>"] = { "snippet_forward", "fallback" },
				["<C-l>"] = { "snippet_backward", "fallback" },
			},

			cmdline = {
				enabled = true,
				completion = { menu = { auto_show = true } },
			},

			appearance = {
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 150,
					window = { border = "rounded" },
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					},
				},
				menu = { border = "none" },
			},

			fuzzy = {
				-- implementation = "lua",
				implementation = "prefer_rust_with_warning",
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`
			sources = {
				default = {
					"copilot",
					"lsp",
					"path",
					"buffer",
					"lazydev",
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
						opts = {
							max_completions = 3,
							max_attempts = 2,
						},
					},
					buffer = {
						score_offset = -100,
					},
				},
				-- optionally disable cmdline completions
				-- cmdline = {},
			},

			-- experimental signature help support
			signature = {
				enabled = true,
				trigger = { show_on_insert_on_trigger_character = true },
				window = { border = "rounded" },
			},
		},
		-- allows extending the providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
	},
}
