local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
	icon = {
		font = { size = settings.font_sizes.icon_medium },
		string = icons.apple,
		padding_right = 8,
		padding_left = 8,
	},
	label = { drawing = false },
	padding_left = 1,
	padding_right = 1,
})

sbar.add("bracket", { apple.name }, {
	background = colors.island,
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
