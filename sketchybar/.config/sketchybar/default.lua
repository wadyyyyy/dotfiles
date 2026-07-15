local settings = require("settings")
local colors = require("colors")

sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = settings.sizes.icon_small,
		},
		color = colors.white,
		padding_left = settings.paddings.paddings,
		padding_right = settings.paddings.paddings,
		background = { image = { corner_radius = settings.ui.item_corner_radius } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = settings.sizes.label_large,
		},
		color = colors.white,
		padding_left = settings.paddings.paddings,
		padding_right = settings.paddings.paddings,
	},
	background = {
		height = settings.ui.item_height,
		corner_radius = settings.ui.item_corner_radius,
		border_width = settings.ui.item_border_width,
		border_color = colors.bg2,
		image = {
			corner_radius = settings.ui.item_image_corner_radius,
			border_color = colors.grey,
			border_width = 2,
		},
	},
	padding_left = 5,
	padding_right = 5,
	scroll_texts = true,
})
