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
})

local battery_icon = sbar.add("item", "widgets.battery.icon", {
	position = "right",
	icon = {
		string = "BAT",
		color = colors.blue,
		font = settings.label_font,
		align = "center",
	},
	width = 20,
	label = { drawing = false },
	update_freq = settings.widgets.battery.update_freq,
})

sbar.add("bracket", "widgets.battery.bracket", {
	battery_icon.name,
	battery_label.name,
}, {
	background = colors.island,
})

sbar.add("item", "widgets.battery.padding", {
	position = "right",
	width = settings.group_padding,
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
				color = colors.orange
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
