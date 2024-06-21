-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

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
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		key = "-",
		mods = "SUPER",
		action = wezterm.action.DecreaseFontSize,
	},
	{
		key = "+",
		mods = "SUPER",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "0",
		mods = "SUPER",
		action = wezterm.action.ResetFontSize,
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
	{
		key = "1",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(0),
	},
	{
		key = "2",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(1),
	},
	{
		key = "3",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(2),
	},
	{
		key = "4",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(3),
	},
	{
		key = "5",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(4),
	},
	{
		key = "6",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(5),
	},
	{
		key = "7",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(6),
	},
	{
		key = "8",
		mods = "SUPER",
		action = wezterm.action.ActivateTab(7),
	},
}

-- For example, changing the color scheme:
-- config.color_scheme = "OneDark (base16)"
config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "Catppuccin Latte"

-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font("JetBrains Mono")
config.font_size = 11.0
config.cursor_thickness = "0.5pt"

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
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "MacOsNative"
config.use_fancy_tab_bar = true

config.initial_cols = 160
config.initial_rows = 50

-- and finally, return the configuration to wezterm
return config
