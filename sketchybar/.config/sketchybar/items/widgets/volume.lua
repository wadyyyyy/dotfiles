local colors = require("colors")
-- local icons = require("icons")
local settings = require("settings")

local volume_percent = sbar.add("item", "widgets.volume.percent", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??%",
		font = settings.label_font,
		color = colors.white,
	},
	width = 20,
	align = "center",
})

local volume_icon = sbar.add("item", "widgets.volume.icon", {
	position = "right",
	icon = {
		string = "VOL",
		color = colors.blue,
		font = settings.label_font,
		align = "center",
	},
	width = 20,
	label = { drawing = false },
})

sbar.add("bracket", "widgets.volume.bracket", {
	volume_icon.name,
	volume_percent.name,
}, {
	background = colors.island,
})

sbar.add("item", "widgets.volume.padding", {
	position = "right",
	width = settings.group_padding,
})

volume_percent:subscribe("volume_change", function(env)
	local volume = tonumber(env.INFO) or 0

	local lead = ""
	if volume < 10 then
		lead = "0"
	end

	volume_percent:set({
		label = { string = lead .. volume .. "%" },
	})
end)
