-- This sounds like a theme.lua with extra steps

-- local pulse = require 'pulseaudio_widget'
local awful = require 'awful'
local wibox = require 'wibox'
local layout = awful.layout.suit

return {
   terminal = 'alacritty',
   browser = 'firefox',
   editor = 'nvim',
   modkey = 'Mod4',
   layouts = {
      -- lain.layout.centerwork,
      layout.tile,
      -- layout.floating,
      layout.spiral,
      layout.max
   },
   autostart = {
      'picom --experimental-backends &',
      'nitrogen --restore',
      'xrandr --output HDMI-0 --primary',
      'xrandr --output HDMI-0 --left-of DVI-D-0'
   },
   bar = function()
      return {
         {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            -- lain.widget.cpu {
            --    settings = function()
            --       widget:set_markup(' ' .. cpu_now.usage .. '%')
            --    end
            -- },
            -- lain.widget.mem {
            --    settings = function()
            --       widget:set_markup(' ' .. mem_now.perc .. '%')
            --    end
            -- },
            wibox.widget.textclock('%T', 1),
         }
      }
   end,
   keybindings = awful.util.table.join(
      -- Audio
      awful.key({ }, 'XF86AudioNext', function()
         awful.spawn.with_shell('sp next')
      end),
      awful.key({ }, 'XF86AudioPrev', function()
         awful.spawn.with_shell('sp prev')
      end),
      awful.key({ }, 'XF86AudioStop', function()
         awful.spawn.with_shell('sp pause')
      end),
      awful.key({ }, 'XF86AudioPlay', function()
         awful.spawn.with_shell('sp play')
      end)
   ),
   layout = 1,
   tags = {
      {'', '', '', ''},
      {'', '', '', ''}
   }
}
