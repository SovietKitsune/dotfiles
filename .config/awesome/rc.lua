-- Load Luarocks
pcall(require, 'luarocks.loader')

local hotkeys_popup = require 'awful.hotkeys_popup'

local beautiful = require 'beautiful'

local naughty = require 'naughty'

-- Utility and standard libraries
local gears = require 'gears'

local awful = require 'awful'
-- Widgets
local wibox = require 'wibox'

local ruled = require 'ruled'

require 'awful.autofocus'
require 'awful.hotkeys_popup.keys'

beautiful.init(os.getenv('HOME') .. '/.config/awesome/theme.lua')

local nice = require 'nice'

nice {
   titlebar_color = '#373E4D',
   titlebar_height = 28,
   titlebar_items = {
      left = { 'close', 'minimize', 'maximize' },
      middle = '',
      right = {}
   },
   close_color = '#eb3b5a',
   minimize_color = '#4b7bec',
   maximize_color = '#a55eea'
}

local config = require 'config'
local modkey = config.modkey

awful.layout.append_default_layouts(config.layouts)

local taglistButtons = gears.table.join(
   awful.button({}, 1, function(t)
      t:view_only()
   end),
   awful.button({config.modkey}, 1, function(t)
      if client.focus then
         client.focus.move_to_tag(t)
      end
   end),
   awful.button({}, 3, awful.tag.viewtoggle),
   awful.button({}, 4, function(t)
      awful.tag.viewnext(t.screen)
   end),
   awful.button({}, 5, function(t)
      awful.tag.viewprev(t.screen)
   end)
)

local tasklistButtons = gears.table.join(
   awful.button({ }, 1, function (c)
      if c == client.focus then
         c.minimized = true
      else
         c:emit_signal('request::activate', 'tasklist', {raise = true})
      end
   end)
)

awful.screen.connect_for_each_screen(function(screen)
   local layout = awful.layout.layouts[config.layout]
   local tags = config.tags

   if type(config.layouts[1]) == 'table' then
      tags = tags[screen.index]
   end

   awful.tag(tags, screen, layout)

   screen.my_taglist = awful.widget.taglist {
      screen = screen,
      filter = awful.widget.taglist.filter.all,
      buttons = taglistButtons,
      widget_template = {
         widget = wibox.container.background,
         id = 'background_role',
         left = 12.5,
         {
            left  = 12.5,
            right = 12.5,
            widget = wibox.container.margin,
            {
               id = 'text_role',
               widget = wibox.widget.textbox
            }
         }
      }
   }

   screen.my_tasklist = awful.widget.tasklist {
      screen = screen,
      filter = awful.widget.tasklist.filter.minimizedcurrenttags,
      buttons = tasklistButtons
   }

   screen.my_wibox = awful.wibar {
      position = 'top',
      screen = screen
   }

   local configBar = config.bar()

   local wiboxSetup = {
      layout = wibox.layout.align.horizontal,
      screen.my_taglist,
      screen.my_tasklist
   }

   for _, v in pairs(configBar) do
      table.insert(wiboxSetup, v)
   end

   screen.my_wibox:setup(wiboxSetup)
end)

local globalKeys = gears.table.join(
   -- Help
   config.keybindings,
   awful.key({modkey}, 's', hotkeys_popup.show_help),
   -- Movement
   awful.key({modkey}, 'Left', awful.tag.viewprev),
   awful.key({modkey}, 'Right', awful.tag.viewnext),
   awful.key({modkey}, 'j', function()
      awful.client.focus.byidx(1)
   end),
   awful.key({modkey}, 'k', function()
      awful.client.focus.byidx(-1)
   end),
   awful.key({modkey, 'Shift'}, 'j', function()
      awful.client.swap.byidx(1)
   end),
   awful.key({modkey, 'Shift'}, 'k', function()
      awful.client.swap.byidx(-1)
   end),
   awful.key({modkey, 'Control'}, 'j', function()
      awful.screen.focus_relative(-1)
   end),
   awful.key({modkey, 'Control'}, 'k', function()
      awful.screen.focus_relative(1)
   end),
   -- Awesome & Terminal and some other things
   awful.key({modkey}, 'Return', function()
      awful.spawn(config.terminal)
   end),
   awful.key({modkey}, 'b', function()
      awful.spawn(config.browser)
   end),
   awful.key({modkey, 'Control'}, 'r', awesome.restart),
   awful.key({modkey, 'Shift'}, 'q', awesome.quit),
   awful.key({modkey}, 'r', function()
      awful.spawn('dmenu_run')
   end),
   awful.key({modkey}, 'p', function()
      awful.spawn('flameshot gui')
   end),
   -- Size
   awful.key({modkey}, 'l', function()
      awful.tag.incmwfact(0.05)
   end),
   awful.key({modkey}, 'h', function()
      awful.tag.incmwfact(-0.05)
   end),
   awful.key({modkey, 'Shift'}, 'h', function()
      awful.tag.incnmaster(1, nil, true)
   end),
   awful.key({modkey, 'Shift'}, 'l', function()
      awful.tag.incnmaster(-1, nil, true)
   end),
   awful.key({modkey, 'Control'}, 'h', function()
      awful.tag.incncol(1, nil, true)
   end),
   awful.key({modkey, 'Control'}, 'l', function()
      awful.tag.incncol(-1, nil, true)
   end),
   -- Layout
   awful.key({modkey}, 'space', function()
      awful.layout.inc(1)
   end),
   awful.key({modkey, 'Shift'}, 'space', function()
      awful.layout.inc(-1)
   end)
   -- Run prompt
   -- Should maybe use something like dmenu
)

local clientKeys = gears.table.join(
   awful.key({modkey}, 'f', function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
   end),
   awful.key({modkey, 'Shift'}, 'c', function(c)
      c:kill()
   end),
   awful.key({modkey}, 'o', function(c)
      c:move_to_screen()
   end)
)

-- Tag bindings
for i = 1, 9 do
   globalKeys = gears.table.join(
      globalKeys,
      awful.key({modkey}, '#' .. i + 9, function()
         local screen = awful.screen.focused()
         local tag = screen.tags[i]

         if tag then
            tag:view_only()
         end
      end),
      awful.key({modkey, 'Control'}, '#' .. i + 9, function()
         local screen = awful.screen.focused()
         local tag = screen.tags[i]

         if tag then
            awful.tag.viewtoggle(tag)
         end
      end),
      awful.key({modkey, 'Shift'}, '#' .. i + 9, function()
         if client.focus then
            local tag = client.focus.screen.tags[i]

            if tag then
               client.focus:move_to_tag(tag)
            end
         end
      end)
   )
end

local clientButtons = gears.table.join(
   awful.button({}, 1, function(c)
      c:emit_signal('request::activate', 'mouse_clock', {raise = true})
   end)
)

root.keys(globalKeys)

ruled.client.append_rule {
   rule = {},
   properties = {
      border_width = beautiful.border_width,
         border_color = beautiful.border_color,
         focus = awful.client.focus.filter,
         keys = clientKeys,
         buttons = clientButtons,
         screen = awful.screen.preferred,
         placement = awful.placement.no_overlap + awful.placement.no_offscreen,
         titlebars_enabled = true
   }
}

naughty.connect_signal('request::display', function(n)
   naughty.layout.box { notification = n }
end)

client.connect_signal('manage', function(c)
   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_offscreen(c)
   end
end)

client.connect_signal('mouse::enter', function(c)
   c:emit_signal('request::activate', 'mouse_enter', {raise = true})
end)

for i = 1, #config.autostart do
   awful.spawn.with_shell(config.autostart[i])
end
