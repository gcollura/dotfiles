-- Pull in the wezterm API
local wezterm = require("wezterm") --[[@as Wezterm]]

-- This will hold the configuration.
local config = wezterm.config_builder()

config.disable_default_key_bindings = true
config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "c",
		mods = "SUPER",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "SUPER",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "p",
		mods = "SUPER",
		action = "ActivateCommandPalette",
	},
	{
		key = "-",
		mods = "SUPER",
		action = "DecreaseFontSize",
	},
	{
		key = "+",
		mods = "SUPER",
		action = "IncreaseFontSize",
	},
	{
		key = "0",
		mods = "SUPER",
		action = "ResetFontSize",
	},
	{
		key = "t",
		mods = "SUPER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "SUPER",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "SUPER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

config.color_scheme = "Catppuccin Frappe"

-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"icons-in-terminal",
	"Material Icons",
	"Symbols Nerd Font Mono",
	"Apple Color Emoji",
	"Apple Symbols",
})
config.font_size = 11.0
---@diagnostic disable-next-line: inject-field
config.cursor_thickness = "0.5pt"
---@diagnostic disable-next-line: assign-type-mismatch
config.allow_square_glyphs_to_overflow_width = "Always"
config.custom_block_glyphs = true
config.cell_width = 1.0

-- config.window_background_opacity = 0.95
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- config.tab_bar_style = {
-- 	enable_tab_bar = false,
-- 	hide_tab_bar_if_only_one_tab = true,
-- }

-- sets up appearance in retro style; monospace font, no extra padding, no symbol glyphs
---@diagnostic disable-next-line: assign-type-mismatch
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "MacOsNative"
config.use_fancy_tab_bar = true

config.initial_cols = 160
config.initial_rows = 50

config.max_fps = 144

-- and finally, return the configuration to wezterm
return config
