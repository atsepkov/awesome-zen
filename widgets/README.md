Widgets
-------
This directory contains a list od widget that you can use in your theme.

## Existing Widgets

### Temperature
A widget that shows current CPU temperature and changes color as the temperature gets higher. It even warns the user when the temperature reaches critical levels.

![Normal](https://github.com/atsepkov/awesome-zen/blob/master/widgets/temperature/1.png)
![High](https://github.com/atsepkov/awesome-zen/blob/master/widgets/temperature/2.png)
![Dangerous](https://github.com/atsepkov/awesome-zen/blob/master/widgets/temperature/3.png)
![Critical](https://github.com/atsepkov/awesome-zen/blob/master/widgets/temperature/4.png)

In case you don't notice the red icon, the widget will grab your attention via a message:
![Critical Notification](https://github.com/atsepkov/awesome-zen/blob/master/widgets/temperature/notification_example.png)

To use this widget, simply add the following to your `rc.lua`:

	myTempWidget = load_widget({
		widget = "widgets.temperature.temp"
	})

And then add the widget to your wibox (here is an example, although your code may look different):

	right_layout:add(myTempWidget)

You could also add an optional callback to `load_widget` that determines when to show/hide the temperature widget:

	myTempWidget = load_widget({
		widget = "widgets.temperature.temp",
		zenstate = function(t) if t < 60 then return true end return false end,
	})

The above example will hide temperature widget when the temperature falls below 60 degrees and show it when it goes above.



## Adding New Widgets
Interested in adding your own widget to `Zen` library? Great!

Make sure your widget follows these `Zen` guidelines, otherwise your pull request may get rejected:

- Your widget must embrace `Zen` philosophy (it must be as minimalistic as possible, remember that "less is more", don't confuse user with excessive options and prompts, don't take up unnecessary real estate on the screen, try to minimize the number of dependencies your widget brings in)
- Your widget must catch all errors that it could generate (It doesn't matter if `awesome` or `bash` is at fault, if as a result of adding your widget user will start seeing occasional red notifications from awesome, your widget will be rejected)
- Your widget must not be dominated by an existing `Zen` widget or perform identical functionality (there is no reason to have 50 volume widgets, for example, they just add clutter and confusion, but if you think your widget is superior to an existing widget by all means submit it). I don't want this repository to become another widget graveyard.
- Your widget must follow `Zen` architecture, it must conform to the `load_widget` options. That basically means the following:
	- You must include a handler for user-defined `zenstate` callback, a function that determines when the widget can hide or change state (you can define inputs for the callback and document them in this README, the function will return a boolean identifying true (show) and false (hide) states)
	- Your widget must be named `widget` by the end of your script, since this is what `load_widget` script assumes as the name and returns to the user
- You must include a brief description and screenshot or two of your widget, awesome WM is cluttered with undocumented widgets that users have no way of previewing before installing. Once again, I don't want this repository to become another widget graveyard.
