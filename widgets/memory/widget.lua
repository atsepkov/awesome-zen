-- Alexander Tsepkov, 2015
--
-- Memory Monitor for awesome that changes color as the memory usage goes up
-- dependency: FontAwesome


local wibox = require("wibox")
local naughty = require("naughty")

local last_id
widget = wibox.widget.textbox()
function testmem()
    local fd = io.popen(os.getenv("HOME") .. "/.config/awesome/widgets/memory/mem.sh simple")
    if fd then
        -- occasionally awesome craps out for no reason running the operation
        -- and fd is nil, do nothing in that case (aside from ignoring the value
        -- rather than throwing an error), it will fix itself next run
        local memstr = fd:read("*all")
        local mem = tonumber(memstr)
        fd:close()
        local color
        local font = "<span font='FontAwesome 8' "
        if mem > 94 then
            color = font .. "color='#FF0000'>"
            last_id = naughty.notify({
                title = "High Memory Usage",
                text = "Consider closing some processes to prevent miserable experience.",
                preset = naughty.config.presets.critical,
                replaces_id = last_id,
                icon = os.getenv("HOME") .. "/.config/awesome/widgets/memory/" .. "max.png"
            }).id
        elseif mem > 85 then
            color = font .. "color='#FF8000'>"
        elseif mem > 75 then
            color = font .. "color='#F5F549'>"
        else
            color = font .. "color='#A9F5A9'>"
        end

        if widget.zenstate ~= nil then
            if widget.zenstate(mem) then
                return ""
            end
        end

        return color .. "" .. mem .. "</span>"
    end
    return "N/A" -- something failed
end

-- update every 30 secs
memtimer = timer({ timeout = 30 })
memtimer:connect_signal("timeout", function() widget:set_markup(testmem()) end)
memtimer:start()
