
-------------------------------------------------
-- Run Shell for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/run-shell

-- @author Pavel Makhov
-- @copyright 2019 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local gears = require("gears")
local completion = require("awful.completion")

local run_shell = awful.widget.prompt()

local widget = {}

function widget.new()

    local widget_instance = {
        _cached_wiboxes = {}
    }

    function widget_instance:_create_wibox()
        local w = wibox {
            visible = false,
            ontop = true,
            height = mouse.screen.geometry.height,
            width = mouse.screen.geometry.width,
            opacity = 0.9,
            bg = 'radial:'.. mouse.screen.geometry.width/2 .. ','
                    .. mouse.screen.geometry.height/2 .. ',20:'
                    .. mouse.screen.geometry.width/2 .. ','
                    .. mouse.screen.geometry.height/2
                    .. ',700:0,#2E344022:0.2,#4C566A88:1,#2E3440ff'
        }

        w:setup {
            {
                {
                    {
                        {
                            run_shell,
                            left = 10,
                            layout = wibox.container.margin,
                        },
                        id = 'left',
                        layout = wibox.layout.fixed.horizontal
                    },
                    bg = '#333333',
                    shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, 3)
                    end,
                    shape_border_color = '#74aeab',
                    shape_border_width = 1,
                    forced_width = 200,
                    forced_height = 50,
                    widget = wibox.container.background
                },
                valign = 'center',
                layout = wibox.container.place
            },
            {
                {
                    layout = wibox.layout.fixed.horizontal
                },
                valign = 'bottom',
                layout = wibox.container.place,
            },
            layout = wibox.layout.stack
        }

        return w
    end

    function widget_instance:launch()
        local s = mouse.screen
        if not self._cached_wiboxes[s] then
            self._cached_wiboxes[s] = {}
        end
        if not self._cached_wiboxes[s][1] then
            self._cached_wiboxes[s][1] = self:_create_wibox()
        end
        local w = self._cached_wiboxes[s][1]
        w.visible = true
        awful.placement.top(w, { margins = { top = 20 }, parent = awful.screen.focused() })
        awful.prompt.run {
            prompt = 'Run: ',
            bg_cursor = '#74aeab',
            textbox = run_shell.widget,
            completion_callback = completion.shell,
            exe_callback = function(...)
                awful.spawn.with_shell(...)
            end,
            history_path = gfs.get_cache_dir() .. "/history",
            done_callback = function() w.visible = false end
        }
    end

    return widget_instance
end

local function get_default_widget()
    if not widget.default_widget then
        widget.default_widget = widget.new()
    end
    return widget.default_widget
end

function widget.launch(...)
    return get_default_widget():launch(...)
end

return widget
