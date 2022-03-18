local wezterm = require 'wezterm';

return {
  hide_tab_bar_if_only_one_tab = true,
  color_scheme = "wezterm_tokyonight_night",
  window_background_opacity = 0.98,
  font = wezterm.font("JetBrains Mono"),
  font_size = 14.0,
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}

