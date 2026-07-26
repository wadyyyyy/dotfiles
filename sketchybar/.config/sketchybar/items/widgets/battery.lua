local colors = require("colors")
local settings = require("settings")

local battery_label = sbar.add("item", "widgets.battery.label", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??%",
		font = settings.label_font,
		color = colors.white,
		align = "center",
	},
	padding_right = settings.paddings.paddings,
	padding_left = settings.paddings.group_padding,
})

local battery_icon = sbar.add("item", "widgets.battery.icon", {
	position = "right",
	label = { drawing = false },
	icon = {
		string = "BAT",
		color = colors.blue,
		font = settings.label_font,
		align = "center",
	},
	padding_left = settings.paddings.paddings,
	update_freq = settings.widgets.battery.update_freq,
})

sbar.add("item", "widgets.battery.spacer", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	width = settings.paddings.container_paddings,
})

sbar.add("bracket", {
	"widgets.battery.label",
	"widgets.battery.icon",
}, {
	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		y_offset = settings.ui.container.y_offset,
	},
})

battery_icon:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(batt_info)
		local found, _, charge = batt_info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
			label = charge .. "%"
		end

		local color = colors.white
		local charging, _, _ = batt_info:find("AC Power")

		if charging then
			color = colors.green
		else
			if charge < 20 then
				color = colors.red
			else
				color = colors.blue
			end
		end

		local lead = ""
		if found and charge < 10 then
			lead = "0"
		end

		battery_icon:set({
			icon = {
				string = charging and "+BAT" or "BAT",
				color = color,
			},
		})

		battery_label:set({
			label = { string = lead .. label },
		})
	end)
end)
