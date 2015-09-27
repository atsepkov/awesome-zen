-- Alexander Tsepkov, 2015
--
-- Collection of utilities for awesome WM to import/use awesome-zen platform better.


local awful = require("awful")
local naughty = require("naughty")


-- spawn a system tool/utility once, useful for those pesky system tray icons that keep stacking with themselves, 
-- also can be used to load anything, including compositor, etc.
function spawn_once_name(name, command)
    os.execute("pgrep " .. name .. " || " .. command .. " &")
end
function spawn_once(name)
    spawn_once_name(name, name)
end

-- loads a widget
function load_widget(loc, notify)
    require(loc)
    if notify then
        naughty.notify({
            title = "Widget Loaded",
            text = "Loaded " .. loc
        })
    end
    return widget
end

-- load utility if not loaded yet, if loaded avoid loading it twice, print message if asked
function load_script(name, notify)
    local success
    local result

    -- Which file? In rc/ or in lib/?
    local path = awful.util.getdir("config") ..
        "/" .. name .. ".lua"

    -- Execute the RC/module file
    success, result = pcall(function() return dofile(path) end)
    if not success then
        naughty.notify({
            title = "Error Loading Script",
            text = "When loading `" .. name .. "`, got the following error:\n" .. result,
            preset = naughty.config.presets.critical
        })
        return print("E: error loading script: '" .. name .. "': " .. result)
    elseif notify then
        naughty.notify({
            title = "Script Loaded",
            text = "Loaded " .. name
        })
    end

    return result
end
