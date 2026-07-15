local settings = require("settings")

local colors = {
	black = 0xff1d2021,
	white = 0xffd4be98,

	red = 0xffea6962,
	green = 0xffa9b665,
	blue = 0xff7daea3,
	yellow = 0xffd8a657,
	orange = 0xffe78a4e,
	magenta = 0xffd3869b,
	grey = 0xff928374,

	transparent = 0x00000000,

	bar = {
		bg = 0xb3202020,
		border_color = 0x35e2e2e3,
		blur = 12,
	},

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}

return colors
