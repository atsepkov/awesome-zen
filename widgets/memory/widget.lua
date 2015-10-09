-- Alexander Tsepkov, 2015
--
-- Memory Monitor for awesome that changes color as the memory usage goes up
-- dependency: FontAwesome


local awful = require("awful")
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
            color = font .. "color='#669900'>"
        end

        if widget.zenstate ~= nil then
            if widget.zenstate(mem) then
                return ""
            end
        end

        return color .. "" .. mem .. " </span>"
    end
    return "N/A " -- something failed
end

-- to display on hover event
local summary = nil
function show_tooltip()
    local font = 'monospace 8'
    local text_color = '#FFFFFF'
    local fd = io.popen(os.getenv("HOME") .. "/.config/awesome/widgets/memory/mem.sh summary")
    local str = fd:read("*all")
    local content = string.format('<span font="%s" foreground="%s">%s</span>', font, text_color, str)
    summary = naughty.notify({
--        title = "Memory Usage",
        text = content,
        timeout = 0,
        hover_timeout = 0.5,
        width = 60*8
    })
end

function hide_tooltip()
    if summary ~= nil then
        naughty.destroy(summary)
    end
end

widget:set_markup(testmem())
widget:connect_signal("mouse::enter", show_tooltip)
widget:connect_signal("mouse::leave", hide_tooltip)

-- update every 30 secs
memtimer = timer({ timeout = 30 })
memtimer:connect_signal("timeout", function()
    widget:set_markup(testmem())
end)
memtimer:start()
