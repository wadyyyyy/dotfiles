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
		bg = 0x00000000,
		border = 0xff747195,
	},
	popup = {
		-- bg = 0xc02c2e34,
		bg = 0x00000000,
		border = 0xff7f8490,
	},
	-- bg1 = 0x88363944,
	bg2 = 0x88414550,

	bg1 = 0xff111111,
	-- bg2 = 0xff111111,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}

-- local colors = {
-- 	-- Catppuccin Macchiato
-- 	black = 0xff1e2030, -- Mantle (основной темный)
-- 	white = 0xffcad3f5, -- Text
-- 	red = 0xfeed8794, -- Red
-- 	green = 0xffa6da95, -- Green
-- 	blue = 0xff8aadf4, -- Blue
-- 	yellow = 0xffeed49f, -- Yellow
-- 	orange = 0xfff5a97f, -- Peach
-- 	magenta = 0xffc6a0f6, -- Mauve
-- 	grey = 0xff5b6078, -- Surface 1
-- 	transparent = 0x00000000,
--
-- 	bar = {
-- 		-- catpuccin
-- 		-- bg = 0xbb24273a,
-- 		-- border = 0xff363a4f,
-- 	},
--
-- 	-- Настройки всплывающих окон (Popups)
-- 	popup = {
-- 		bg = 0x201e2030, -- Более темный плотный Mantle для читаемости
-- 		border = 0xff5b6078, -- Surface 1
-- 	},
--
-- 	-- Дополнительные подложки для "островков" (активных элементов)
-- 	bg1 = 0xbb363a4f, -- Surface 0
-- 	bg2 = 0xbb494d64, -- Surface 1
--
-- 	-- Твоя функция динамической альфы (оставляем, она отличная)
-- 	with_alpha = function(color, alpha)
-- 		if alpha > 1.0 or alpha < 0.0 then
-- 			return color
-- 		end
-- 		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
-- 	end,
-- }

-- Shared pill style for bar item groups (menus, apple, spaces, widgets, calendar)
colors.island = {
	color = colors.bg1,
	height = settings.ui.item_height,
	corner_radius = settings.ui.item_corner_radius,
	border_width = settings.ui.item_border_width,
	border_color = colors.bg2,
}

return colors
