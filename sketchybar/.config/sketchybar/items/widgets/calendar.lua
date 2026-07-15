local settings = require("settings")
local colors = require("colors")

local cal_time = sbar.add("item", "widgets.calendar.time", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??:??",
		color = colors.white,
		font = settings.label_font,
		align = "center",
	},
	padding_right = settings.edge_padding,
})

local cal_date = sbar.add("item", "widgets.calendar.date", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??/??",
		color = colors.white,
		font = settings.label_font,
		align = "center",
	},
	update_freq = settings.widgets.calendar.update_freq,
})

sbar.add("bracket", "widgets.calendar.bracket", {
	cal_date.name,
	cal_time.name,
}, {
	background = colors.island,
})

sbar.add("item", "widgets.calendar.padding", {
	position = "right",
	width = settings.group_padding,
})

cal_date:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_date:set({
		label = { string = os.date("%d/%m") },
	})
	cal_time:set({
		label = { string = os.date("%H:%M") },
	})
end)
