-- Alexander Tsepkov, 2015
--
-- Minimalistic Volume Widget that works with multiple output sources
-- dependency: FontAwesome


local wibox = require("wibox")
local naughty = require("naughty")

local last_id
local vol_muted
function mixercommand(command)
    local fd = io.popen(os.getenv("HOME") .. "/.config/awesome/pa-vol.sh " .. command)
    local status = fd:read("*all")
    fd:close()
    local pic = os.getenv("HOME") .. "/.config/awesome/widgets/volume/"
    local value
    if status == "Muted\n" then
        pic = pic .. "audio-muted.png"
    else
        -- dividing by 26 is a little cheat to prevent overflow on 100%
        value = math.floor(tonumber(string.sub(status:gsub("%s+$", ""), 0, -2)) / 26)
        pic = pic .. "audio-" .. value .. ".png"
    end
    last_id = naughty.notify({
        title = "Volume",
        text = status,
        replaces_id = last_id,
        icon = pic,
    }).id
end
function volumeup()
    mixercommand("plus")
end

function volumedown()
    mixercommand("minus")
end

function volumetoggle()
    mixercommand("mute")
end

-- zenstate not applicable bescause there is no volume icon for this widget at all

-- this widget doesn't have an icon, I use volumeicon instead but I prefer the messages/control through this
-- widget instead
widget = {
    up = volumeup,
    down = volumedown,
    toggle = volumetoggle,
}
