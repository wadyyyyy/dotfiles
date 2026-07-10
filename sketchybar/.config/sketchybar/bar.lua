local colors = require("colors")
local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
	height = settings.ui.bar_height,
	color = colors.bar.bg,
	padding_right = 10,
	padding_left = 10,
	display = 1,
})
