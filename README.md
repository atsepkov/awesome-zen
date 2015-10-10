Awesome Zen
-----------
A collection of polished widgets and utilities for Awesome WM which can be cherry-picked into your config.

## Installation
Place `bootstrap.lua` and other directories into your `~/.config/awesome/` folder. Add the following command to your `rc.lua` file:

	dofile(os.getenv("HOME") .. "/.config/awesome/bootstrap.lua")

Now refer to the individual README for each widget/utility and cherry-pick the ones you want.

Importing `bootstrap.lua` via the command above also allows you a number of useful commands in your rc.lua:

### spawn_once
Spawn a command once and only once, regardless of how many times this function is called, for example to avoid loading multiple instances of compositor or multiple volume icons in dock:

    spawn_once("compton")
    spawn_once("volumeicon")

### spawn_once_name
Same as above but allows you different name and command. For example, say you want to activate numlock on boot up, the command you want to search for in process tree is `numlockx` (if it's already running, we don't need to do anything), but the actual command to start numlock is `numlockx on`, you'd add the following to your rc.lua:

    spawn_once_name("numlockx", "numlockx on")

### load_script
Load script relative to `.config/awesome` directory, optionally takes a second argument that will notify that script loaded if set to `true`. Use this to load scripts from this repo or even your own, since it has safety mechanism already built in should script fail or path be incorrect.

### load_widget
Load widget into your task bar. You can define the following options:

	widget:	name of the widget to Load
	zenstate (optional): callback that determines whether the hide the widget, omitting this will put widget in always-on state
	notify: generate notification message when widget is loaded (useful for debugging or tracking which widgets loaded)

### equals
Deep equality test function since out of the box lua fails to compare tables properly.

	if equals(table1, table2) then
		-- tables equal
	end


