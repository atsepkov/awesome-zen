-- Alexander Tsepkov, 2015
--
-- By default awesome forgets window positions when you switch between layouts, this is especially a problem
-- for floating layout, which awesome wasn't designed to handle gracefully out of the box. This tidbit of code
-- fixes that issue by remembering window positions in floating layout and coming back to the same positions when
-- you return to floating layout from a tiling one.
local awful = require("awful")

floatgeoms = {}

tag.connect_signal("property::layout", function(t)
    for k, c in ipairs(t:clients()) do
        if ((awful.layout.get(mouse.screen) == awful.layout.suit.floating)
        or (awful.client.floating.get(c) == true)) then
            c:geometry(floatgeoms[c.window])
        end
    end
    client.connect_signal("unmanage", function(c) floatgeoms[c.window] = nil end)
end)

client.connect_signal("property::geometry", function(c)
    if ((awful.layout.get(mouse.screen) == awful.layout.suit.floating) or (awful.client.floating.get(c) == true)) then
        floatgeoms[c.window] = c:geometry()
    end
end)

client.connect_signal("unmanage", function(c) floatgeoms[c.window] = nil end)

client.connect_signal("manage", function(c)
    if ((awful.layout.get(mouse.screen) == awful.layout.suit.floating) or (awful.client.floating.get(c) == true)) then
        floatgeoms[c.window] = c:geometry()
    end
end)
