-- Alexander Tsepkov, 2015
--
-- Logic to compute window positions in order to tile them on the fly, even when in floating layout


local awful = require("awful")

local position = {}

local capi =
{
    client = client,
    mouse = mouse,
    screen = screen,
    wibox = wibox,
    awesome = awesome,
}
local coords = {
    left = {
        x = 0,
        y = 0,
        h = 1,
        w = 1 / 2
    },
    right = {
        x = 1 / 2,
        y = 0,
        h = 1,
        w = 1 / 2
    },
    top = {
        x = 0,
        y = 0,
        h = 1 / 2,
        w = 1,
    },
    bottom = {
        x = 0,
        y = 1 / 2,
        h = 1 / 2,
        w = 1
    },
    top_left = {
        x = 0,
        y = 0,
        h = 1 / 2,
        w = 1 / 2
    },
    top_right = {
        x = 1 / 2,
        y = 0,
        h = 1 / 2,
        w = 1 / 2
    },
    bottom_left = {
        x = 0,
        y = 1 / 2,
        h = 1 / 2,
        w = 1 / 2
    },
    bottom_right = {
        x = 1 / 2,
        y = 1 / 2,
        h = 1 / 2,
        w = 1 / 2
    },
    fullscreen = {
        x = 0,
        y = 0,
        h = 1,
        w = 1
    },
    center_pad = {
        x = 1 / 8,
        y = 1 / 8,
        h = (1 / 4) * 3,
        w = (1 / 4) * 3
    },
    left_third = {
        x = 0,
        y = 0,
        h = 1,
        w = 1 / 3
    },
    middle_third = {
        x = (1 / 3),
        y = 0,
        h = 1,
        w = 1 / 3
    },
    left_two_thirds = {
        x = 0,
        y = 0,
        h = 1,
        w = (1 / 3) * 2
    },
    right_third = {
        x = ((1 / 3) * 2),
        y = 0,
        h = 1,
        w = 1 / 3
    },
    right_two_thirds = {
        x = (1 / 3),
        y = 0,
        h = 1,
        w = (1 / 3) * 2
    },
    middle_two_thirds = {
        x = (1 / 6),
        y = 0,
        h = 1,
        w = (1 / 3) * 2
    }
}


-- takes geometry, client window, and parent window (uses entire screen as parent window if omitted)
-- resizes client window based on geometry in relation to parent window. If geometry is a string, uses
-- one of existing geometry presets, if geometry is a table, reads x, y, w, h values from it to determine
-- position and size.
function position.at(geometry, c, p)
    if type(geometry) == "string" then
        geometry = coords[geometry]
    end
    local c = c or capi.client.focus
    local c_geometry = c:geometry()
    local screen = c.screen or awful.screen.getbycoord(c_geometry.x, c_geometry.y)
    local s_geometry
    if p then
        s_geometry = p:geometry()
    else
--        s_geometry = capi.screen[screen].geometry
        s_geometry = capi.screen[screen].workarea
    end
    return c:geometry({
        x = s_geometry.x + s_geometry.width * geometry.x,
        y = s_geometry.y + s_geometry.height * geometry.y,
        width = s_geometry.width * geometry.w,
        height = s_geometry.height * geometry.h
    })
end

-- A smarter version of the above function, computes existing window state to see if it already matches
-- a position above, and stacks direction intuitively
-- Direction should be a string identifying 1 of 4 directions: left, right, top, bottom
function position.compound(direction, c, p)
    local c = c or capi.client.focus
    local c_geometry = c:geometry()
    local screen = c.screen or awful.screen.getbycoord(c_geometry.x, c_geometry.y)
    local s_geometry
    if p then
        s_geometry = p:geometry()
    else
        s_geometry = capi.screen[screen].workarea
    end

    empirical_geometry = {
        x = (c_geometry.x - s_geometry.x) / s_geometry.width,
        y = (c_geometry.y - s_geometry.y) / s_geometry.height,
        h = c_geometry.height / s_geometry.height,
        w = c_geometry.width / s_geometry.width
    }

    -- figure out if we're already in one of the preset states
    local state = nil
    for key, val in pairs(coords) do
        if equals(val, empirical_geometry) then
            state = key
            break
        end
    end

--    local naughty = require('naughty')
--    naughty.notify({text=dump(empirical_geometry)})
    local geometry
    if state == nil then
        -- just starting, no stack yet
        geometry = coords[direction]
    elseif direction == 'left' then
        -- stacking left
        if state == 'left' then
            geometry = coords['left_third']
        elseif state == 'top' then
            geometry = coords['top_left']
        elseif state == 'bottom' then
            geometry = coords['bottom_left']
        elseif state == 'right' then
            geometry = coords['middle_third']
        elseif state == 'middle_third' or state == 'center_pad' then
            geometry = coords['left']
        elseif state == 'right_third' then
            geometry = coords['right']
        elseif state == 'top_right' then
            geometry = coords['top']
        elseif state == 'bottom_right' then
            geometry = coords['bottom']
        end
    elseif direction == 'right' then
        -- stacking right
        if state == 'right' then
            geometry = coords['right_third']
        elseif state == 'top' then
            geometry = coords['top_right']
        elseif state == 'bottom' then
            geometry = coords['bottom_right']
        elseif state == 'left' then
            geometry = coords['middle_third']
        elseif state == 'middle_third' or state == 'center_pad' then
            geometry = coords['right']
        elseif state == 'left_third' then
            geometry = coords['left']
        elseif state == 'top_left' then
            geometry = coords['top']
        elseif state == 'bottom_left' then
            geometry = coords['bottom']
        end
    elseif direction == 'top' then
        -- stacking up
        if state == 'left' or state == 'left_third' then
            geometry = coords['top_left']
        elseif state == 'bottom' or state == 'middle_third' then
            geometry = coords['center_pad']
        elseif state == 'right' or state == 'right_third' then
            geometry = coords['top_right']
        elseif state == 'center_pad' then
            geometry = coords['top']
        elseif state == 'bottom_left' then
            geometry = coords['left']
        elseif state == 'bottom_right' then
            geometry = coords['right']
        end
    elseif direction == 'bottom' then
        -- stacking down
        if state == 'left' or state == 'left_third' then
            geometry = coords['bottom_left']
        elseif state == 'top' or state == 'middle_third' then
            geometry = coords['center_pad']
        elseif state == 'right' or state == 'right_third' then
            geometry = coords['bottom_right']
        elseif state == 'center_pad' then
            geometry = coords['bottom']
        elseif state == 'top_left' then
            geometry = coords['left']
        elseif state == 'top_right' then
            geometry = coords['right']
        end
    end

    if geometry == nil then return c:geometry() end
    return c:geometry({
        x = s_geometry.x + s_geometry.width * geometry.x,
        y = s_geometry.y + s_geometry.height * geometry.y,
        width = s_geometry.width * geometry.w,
        height = s_geometry.height * geometry.h
    })
end

return position
