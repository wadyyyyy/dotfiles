local settings = require("settings")

local colors = {
	black = 0xff181819,
	white = 0xffe2e2e3,
	red = 0xfffc5d7c,
	green = 0xff9ed072,
	blue = 0xff76cce0,
	yellow = 0xffe7c664,
	orange = 0xfff39660,
	magenta = 0xffb39df3,
	grey = 0xff7f8490,
	transparent = 0x00000000,

	bar = {
		bg = 0xb3202020,
		border_color = 0x35e2e2e3,
	},
	popup = {
		-- bg = 0xc02c2e34,
		bg = 0x00000000,
		border = 0xff7f8490,
	},

	-- element container color
	-- bg1 = 0x44363944,
	-- bg1 = 0xff111111,
	bg1 = 0x10e2e2e3,

	-- element container border color
	-- bg2 = 0xff111111,
	-- bg2 = 0x88414550, -- last one
	bg2 = 0x40e2e2e3,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}

-- Shared pill style for bar item groups (menus, apple, spaces, widgets, calendar)
colors.island = {
	color = colors.bg1,
	height = settings.ui.item_height,
	corner_radius = settings.ui.item_corner_radius,
	border_width = settings.ui.item_border_width,
	border_color = colors.bg2,
}

return colors
