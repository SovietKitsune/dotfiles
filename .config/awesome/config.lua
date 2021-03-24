-- This sounds like a theme.lua with extra steps

-- local pulse = require 'pulseaudio_widget'
local awful = require 'awful'
local wibox = require 'wibox'
local lain = require 'lain'
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
      'xrandr --output DP-1 --primary',
      'xrandr --output DP-1 --left-of HDMI-0'
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
         awful.spawn.with_shell('lollypop -n')
      end),
      awful.key({ }, 'XF86AudioPrev', function()
         awful.spawn.with_shell('lollypop -p')
      end),
      awful.key({ }, 'XF86AudioStop', function()
         awful.spawn.with_shell('lollypop -s')
      end),
      awful.key({ }, 'XF86AudioPlay', function()
         awful.spawn.with_shell('lollypop -t')
      end)
   ),
   layout = 1,
   tags = {
      {'', '', '', ''},
      {'', '', '', ''}
   }
}
