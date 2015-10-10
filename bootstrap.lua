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
function load_widget(config)
    require(config.widget)

    -- if user defined a zenstate, assign it to the widget so it can respond accordingly
    if config.zenstate then
        widget.zenstate = config.zenstate
    end

    -- notify that the widget was loaded, if asked by rc.lua
    if config.notify then
        naughty.notify({
            title = "Widget Loaded",
            text = "Loaded " .. config.widget
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


-- rounding error is pretty bad in lua
local EPSILON = 1e-3
-- compare two tables, because out of the box lua sucks
function equals(a, b)
    if a == b then return true end
    local aType = type(a)
    local bType = type(b)
    if aType == 'number' and bType == 'number' and math.abs(a - b) < EPSILON then return true end
    if aType ~= bType then return false end
    if aType ~= 'table' then return false end

    local seen = {}
    for key, val1 in pairs(a) do
        local val2 = b[key]
        if val2 == nil or equals(val1, val2) == false then
            return false
        end
        seen[key] = true
    end

    for key, _ in pairs(b) do
        if not seen[key] then return false end
    end
    return true
end


-- dump loa table to string
function dump(tbl, indent)
    local output = ''
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            output = output .. formatting .. "\n"
            tprint(v, indent+1)
        elseif type(v) == 'boolean' then
            output = output .. formatting .. tostring(v) .. "\n"
        else
            output = output .. formatting .. v .. "\n"
        end
    end
    return output
end
