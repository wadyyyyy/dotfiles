local settings = require("settings")
local colors = require("colors")

local cal_font = {
	family = settings.font.text,
	style = settings.font.style_map["Bold"],
	size = settings.sizes.label_medium,
}

sbar.add("item", "edge_padding", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	padding_right = settings.paddings.edge_padding,
})

local cal_time = sbar.add("item", "widgets.calendar.time", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??:??",
		color = colors.white,
		font = cal_font,
		align = "center",
	},
	padding_right = settings.paddings.paddings,
	padding_left = settings.paddings.group_padding,
})

local cal_date = sbar.add("item", "widgets.calendar.date", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??/??,",
		color = colors.white,
		font = cal_font,
		align = "center",
	},
	padding_left = settings.paddings.paddings,
	update_freq = settings.widgets.calendar.update_freq,
})

sbar.add("item", "widgets.calendar.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", {
	"widgets.calendar.time",
	"widgets.calendar.date",
}, {
	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		y_offset = settings.ui.container.y_offset,
	},
})

cal_date:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_date:set({
		label = { string = os.date("%d/%m,") },
	})
	cal_time:set({
		label = { string = os.date("%H:%M") },
	})
end)
