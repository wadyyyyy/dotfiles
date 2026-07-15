local colors = require("colors")
local settings = require("settings")

sbar.bar({
	height = settings.ui.bar_height,
	color = colors.bar.bg,
	border_color = colors.bar.border_color,
	border_width = settings.ui.background.border_width,
	blur_radius = colors.bar.blur,
	padding_right = 0,
	padding_left = 0,
	margin = 8,
	y_offset = 8,
	corner_radius = settings.ui.background.corner_radius,
	display = 1,
	position = "right",
})
