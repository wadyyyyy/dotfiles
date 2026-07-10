local font = require("helpers.default_font")

local ui = {
	bar_height = 32,
	item_height = 24,
	item_corner_radius = 9,
	item_border_width = 1,
	item_image_corner_radius = 8,
}

local sizes = {
	icon = 13.0,
	icon_medium = 14.0,
	icon_large = 16.0,
	label = 13.0,
	label_compact = 12.0,
	label_small = 9.0,
	app = 14.0,
}

return {
	ui = ui,
	font_sizes = sizes,

	paddings = 3,
	group_paddings = 5,

	icons = "sf-symbols", -- alternatively available: NerdFont

	font = font,
	label_font = {
		family = font.text,
		style = font.style_map["Bold"],
		size = sizes.label_compact,
	},

	-- Alternatively, this is a font config for JetBrainsMono Nerd Font
	-- font = {
	--   text = "JetBrainsMono Nerd Font", -- Used for text
	--   numbers = "JetBrainsMono Nerd Font", -- Used for numbers
	--   style_map = {
	--     ["Regular"] = "Regular",
	--     ["Semibold"] = "Medium",
	--     ["Bold"] = "SemiBold",
	--     ["Heavy"] = "Bold",
	--     ["Black"] = "ExtraBold",
	--   },
	-- },
}
