local wezterm = require 'wezterm'

wezterm.on('format-window-title', function(tab)
  return string.gsub(tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')
end)

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'nightfox'

config.font = wezterm.font("RobotoMono Nerd Font", {weight="Regular", stretch="Normal", style="Normal"})
config.font_size = 12

config.mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
