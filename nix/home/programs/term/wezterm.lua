local wezterm = require 'wezterm';
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)
return {
    color_scheme = 'Catppuccin Frappe',
    font = wezterm.font 'JetBrains Mono',
    window_background_opacity = 0.64,
    enable_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true
}
