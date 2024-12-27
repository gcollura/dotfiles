return {
	{ ---@type LazyPlugin
		"saghen/blink.cmp",
		enabled = false,
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = {
			{
				"giuxtaposition/blink-cmp-copilot",
				dependencies = {
					{
						"zbirenbaum/copilot.lua",
						opts = {
							suggestion = {
								suggestion = { enabled = false },
								panel = { enabled = false },
							},
						},
					},
				},
			},
			"rafamadriz/friendly-snippets",
		},

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = { preset = "default" },

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
				-- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
				kind_icons = {
					Copilot = "",
				},
			},

			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 50,
				},
				list = {
					selection = "preselect",
				},
				menu = {
					winblend = 15,
					-- draw = {
					-- 	columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
					-- },
				},
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`
			sources = {
				-- default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
				completion = {
					enabled_providers = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"lazydev",
						"copilot",
					},
				},
				providers = {
					-- dont show LuaLS require statements when lazydev has items
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Copilot"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
				},
				-- optionally disable cmdline completions
				-- cmdline = {},
			},

			-- experimental signature help support
			signature = { enabled = true, trigger = { show_on_insert_on_trigger_character = true } },
		},
		-- allows extending the providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
	},
}
