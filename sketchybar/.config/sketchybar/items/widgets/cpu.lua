local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Poll every 5s.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 5.0")

local cpu = sbar.add("item", "widgets.cpu", {
	position = "right",
	background = {
		height = settings.ui.item_height,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = {
		string = icons.cpu,
		color = colors.blue,
		padding_right = settings.paddings + 3,
	},
	label = {
		string = "cpu ??%",
		font = settings.label_font,
		align = "left",
		padding_left = 0,
		width = 33,
	},
	padding_right = settings.paddings,
})

cpu:subscribe("cpu_update", function(env)
	-- Also available: env.user_load, env.sys_load
	local load = tonumber(env.total_load)

	local color = colors.blue
	if load > 30 then
		if load < 60 then
			color = colors.yellow
		elseif load < 80 then
			color = colors.orange
		else
			color = colors.red
		end
	end

	cpu:set({
		icon = { color = color },
		label = env.total_load .. "%",
	})
end)

-- Background around the cpu item
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
	background = colors.island,
})

-- Background around the cpu item
sbar.add("item", "widgets.cpu.padding", {
	position = "right",
	width = settings.group_paddings,
})
