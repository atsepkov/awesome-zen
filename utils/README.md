Utils
-----
This directory contains a list of convenience utilities for awesome WM.

## remember_positions.lua
By default, awesome WM doesn't remember positions of your floating windows when you cycle through different layouts. This can be a problem both to the users who accidentally switched layouts as well as those wishing to temporarily rearrange windows and come back to original layout once they're done with their work. It's also a problem for those reloading their awesome configuration, since it forgets original window positions as well. This script fixes that. To take advantage of it, install it by adding the following line to your `rc.lua`:

	load_script("utils/remember_positions", true)


## ondemand_tile.lua
Move floating window into any corner/tile via convenient shortcuts, i.e:

	local positions = require('utils.ondemand_tile')

	-- later in code
	awful.key({ modkey, "Shift"   }, "Down", function (c) position.at('bottom', c) end),
	awful.key({ modkey, "Shift"   }, "Left", function (c) position.at('left', c) end),
	awful.key({ modkey, "Shift"   }, "Right", function (c) position.at('right', c) end),
	awful.key({ modkey, "Shift"   }, "Up", function (c) position.at('top', c) end),

Positions can be specified as a table `{x, y, w, h}` or as a string to identify one of existing presets:

	left
	right
	top
	bottom
	top_left
	top_right
	bottom_left
	bottom_right
	fullscreen
	center_pad
	left_third
	middle_third
	right_third
	left_two_thirds
	right_two_thirds
	middle_two_thirds

There is also a compound-resize option in positions module. It stacks previous tiling actions on top of each other in an intuitive manner. For example, when the window is on the `left` half of the screen, sending `down` event will move it to `bottom_left` position. In this way you can iterate through most of the presets in an intuitive manner with just 4 shortcuts:

	awful.key({ modkey, "Shift"   }, "Down", function (c) position.compound('bottom', c) end),
	awful.key({ modkey, "Shift"   }, "Left", function (c) position.compound('left', c) end),
	awful.key({ modkey, "Shift"   }, "Right", function (c) position.compound('right', c) end),
	awful.key({ modkey, "Shift"   }, "Up", function (c) position.compound('top', c) end),


