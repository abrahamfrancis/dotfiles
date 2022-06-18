local wezterm = require("wezterm")

return {
	hide_tab_bar_if_only_one_tab = true,
	color_scheme = "nightfox_wezterm",
	window_background_opacity = 1.0,
	font = wezterm.font("JetBrains Mono"),
	font_size = 14.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	keys = {
		{ key = "1", mods = "META", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "META", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "META", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "META", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "META", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "META", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "META", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "META", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "META", action = wezterm.action({ ActivateTab = -1 }) },
	},
}
