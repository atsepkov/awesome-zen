-- Alexander Tsepkov, 2015
--
-- Temperature Monitor for awesome that changes color as the temperature goes up
-- dependency: FontAwesome


local wibox = require("wibox")
local naughty = require("naughty")

local last_id
widget = wibox.widget.textbox()
function testtemps()
    local fd = io.popen(os.getenv("HOME") .. "/.config/awesome/widgets/temperature/sensors.sh")
    if fd then
        -- occasionally awesome craps out for no reason running the operation
        -- and fd is nil, do nothing in that case (aside from ignoring the value
        -- rather than throwing an error), it will fix itself next run
        local tempstr = fd:read("*all")
        local temp = tonumber(tempstr)
        fd:close()
        local color
        local font = "<span font='FontAwesome 8' "
        if temp > 90 then
            color = font .. "color='#FF0000'>"
            last_id = naughty.notify({
                title = "Temperature Critical",
                text = "CPU temperature is dangerously hot, turn it off to prevent damage.",
                preset = naughty.config.presets.critical,
                replaces_id = last_id,
                icon = os.getenv("HOME") .. "/.config/awesome/widgets/temperature/" .. "hot.png"
            }).id
        elseif temp > 80 then
            color = font .. "color='#FF8000'>"
        elseif temp > 70 then
            color = font .. "color='#F5F549'>"
        else
            color = font .. "color='#669900'>"
        end

        if widget.zenstate ~= nil then
            if widget.zenstate(temp) then
                return ""
            end
        end

        return color .. "" .. temp .. " </span>"
    end
    return "N/A " -- something failed
end

widget:set_markup(testtemps())

-- update every 30 secs
temptimer = timer({ timeout = 30 })
temptimer:connect_signal("timeout", function() widget:set_markup(testtemps()) end)
temptimer:start()
