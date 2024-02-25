-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "OneDark (base16)"
config.color_scheme = "Catppuccin Frappe"
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font("JetBrains Mono")

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
-- config.use_fancy_tab_bar = false

config.initial_cols = 160
config.initial_rows = 50

-- and finally, return the configuration to wezterm
return config
