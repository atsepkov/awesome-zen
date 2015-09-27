Utils
-----
This directory contains a list of convenience utilities for awesome WM.

## remember_positions.lua
By default, awesome WM doesn't remember positions of your floating windows when you cycle through different layouts. This can be a problem both to the users who accidentally switched layouts as well as those wishing to temporarily rearrange windows and come back to original layout once they're done with their work. It's also a problem for those reloading their awesome configuration, since it forgets original window positions as well. This script fixes that. To take advantage of it, install it by adding the following line to your `rc.lua`:

	load_script("utils/remember_positions", true)


