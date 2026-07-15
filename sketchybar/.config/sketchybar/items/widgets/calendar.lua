local settings = require("settings")
local colors = require("colors")

local cal_font = {
	family = settings.font.text,
	style = settings.font.style_map["Bold"],
	size = settings.sizes.label_small,
}

local cal_time = sbar.add("item", "widgets.calendar.time", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??:??",
		color = colors.white,
		font = cal_font,
		align = "center",
	},
	padding_right = settings.paddings.edge_padding + settings.paddings.paddings,
	padding_left = settings.paddings.paddings,
})

local cal_date = sbar.add("item", "widgets.calendar.date", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??/??",
		color = colors.white,
		font = cal_font,
		align = "center",
	},

	padding_left = settings.paddings.paddings,
	padding_right = settings.paddings.paddings,

	update_freq = settings.widgets.calendar.update_freq,
})

sbar.add("item", "widgets.calendar.padding", {
	position = "right",
	width = settings.paddings.group_padding,
})

cal_date:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_date:set({
		label = { string = os.date("%d/%m") },
	})
	cal_time:set({
		label = { string = os.date("%H:%M") },
	})
end)
