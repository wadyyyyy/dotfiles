local colors = require("colors")
local settings = require("settings")

local volume_percent = sbar.add("item", "widgets.volume.percent", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??%",
		font = settings.label_font,
		color = colors.white,
		align = "center",
	},
	padding_left = settings.paddings.group_padding,
	padding_right = settings.paddings.paddings,
})

local volume_icon = sbar.add("item", "widgets.volume.icon", {
	position = "right",
	label = { drawing = false },
	icon = {
		string = "VOL",
		color = colors.blue,
		font = settings.label_font,
		align = "center",
	},
	padding_left = settings.paddings.paddings,
})

sbar.add("item", "widgets.volume.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", {
	"widgets.volume.icon",
	"widgets.volume.percent",
}, {
	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		y_offset = settings.ui.container.y_offset,
	},
	padding_left = settings.paddings.paddings,
})

volume_percent:subscribe("volume_change", function(env)
	local volume = tonumber(env.INFO) or 0

	local lead = ""
	if volume < 10 then
		lead = "0"
	end

	volume_percent:set({
		label = { string = lead .. volume .. "%" },
	})
end)
