local colors = require("colors")
local settings = require("settings")

sbar.exec(
	string.format(
		"killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update %.1f",
		settings.widgets.cpu.poll_seconds
	)
)

local cpu_label = sbar.add("item", "widgets.cpu.label", {
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

local cpu_icon = sbar.add("item", "widgets.cpu.icon", {
	position = "right",
	icon = {
		string = "CPU",
		color = colors.blue,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = settings.sizes.label_small,
		},
		align = "center",
	},
	width = 20,
	label = { drawing = false },
})

local function get_cpu_color(load)
	local thresholds = settings.widgets.cpu.thresholds
	if load > thresholds.critical then
		return colors.red
	end
	if load > thresholds.high then
		return colors.orange
	end
	if load > thresholds.medium then
		return colors.yellow
	end
	return colors.blue
end

cpu_icon:subscribe("cpu_update", function(env)
	local load = tonumber(env.total_load) or 0

	cpu_icon:set({
		icon = { color = get_cpu_color(load) },
	})

	cpu_label:set({
		label = { string = string.format("%.0f%%", load) },
	})
end)

sbar.add("bracket", "widgets.cpu.bracket", {
	cpu_icon.name,
	cpu_label.name,
}, {
	background = colors.island,
})

sbar.add("item", "widgets.cpu.padding", {
	position = "right",
	height = settings.group_padding,
})
