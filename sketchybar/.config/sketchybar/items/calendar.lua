local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
	icon = {
		color = colors.white,
		padding_left = 8,
		padding_right = 5,
		font = settings.label_font,
	},
	label = {
		color = colors.white,
		padding_left = 0,
		padding_right = 8,
		width = "dynamic",
		font = settings.label_font,
	},
	position = "right",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
})

sbar.add("bracket", { cal.name }, {
	background = colors.island,
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
