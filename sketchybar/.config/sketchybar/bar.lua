local colors = require("colors")
local settings = require("settings")

sbar.bar({
	height = settings.ui.bar_height,
	color = colors.bar.bg,
	padding_right = 0,
	padding_left = 1,
	display = 1,
	margin = 8,
	y_offset = 8,
	corner_radius = 10,
	border_width = 1,
	border_color = colors.bar.border_color,
	position = "right",
	blur_radius = colors.bar.blur,
})
