local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local yabai_bin = "/opt/homebrew/bin/yabai"
local jq_bin = "/opt/homebrew/bin/jq"

local app_icon_size_medium = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium
local app_icon_size_small = "sketchybar-app-font:Regular:" .. settings.sizes.icon_small

local MAX_SPACES = 15
local MAX_APPS_PER_SPACE = 10

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or value
end

sbar.add("event", "yabai_refresh")

sbar.add("item", "edge_padding", {
	position = "left",
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = settings.paddings.edge_padding,
})

local space_items = {}
local app_slots = {}

for space_id = 1, MAX_SPACES do
	space_items[space_id] = sbar.add("item", "yabai.space." .. space_id, {
		position = "left",
		icon = {
			font = settings.label_font,
			string = tostring(space_id),
			color = colors.white,
			align = "center",
		},
		label = { drawing = false },
		drawing = false,
		padding_left = settings.paddings.paddings,
		padding_right = settings.paddings.paddings,
	})

	app_slots[space_id] = {}
	for app_index = 1, MAX_APPS_PER_SPACE do
		app_slots[space_id][app_index] = sbar.add("item", "yabai.space." .. space_id .. ".app." .. app_index, {
			position = "left",
			icon = { align = "center" },
			label = { drawing = false },
			drawing = false,
			padding_left = settings.paddings.paddings,
			padding_right = settings.paddings.paddings,
		})
	end
end

local function refresh_workspace()
	sbar.delay(0.05, function()
		local spaces_cmd =
			string.format('%s -m query --spaces | %s -r \'.[] | "\\(.index)|\\(.["has-focus"])"\'', yabai_bin, jq_bin)

		sbar.exec(spaces_cmd, function(spaces_output)
			local active_spaces = {}

			for i = 1, MAX_SPACES do
				space_items[i]:set({ drawing = false })
			end

			for line in string.gmatch(spaces_output, "[^\r\n]+") do
				local index_str, has_focus = string.match(line, "^([^|]+)|([^|]+)")
				local index = tonumber(index_str)

				if index and space_items[index] then
					active_spaces[index] = true
					space_items[index]:set({
						drawing = true,
						icon = { color = (has_focus == "true") and colors.blue or colors.white },
					})
				end
			end

			local windows_cmd = string.format(
				'%s -m query --windows | %s -r \'.[]? | "\\(.space)|\\(.["has-focus"])|\\(.app)"\'',
				yabai_bin,
				jq_bin
			)

			sbar.exec(windows_cmd, function(windows_output)
				local apps_by_space = {}

				for line in string.gmatch(windows_output, "[^\r\n]+") do
					local space_str, has_focus, app_name = string.match(line, "^([^|]+)|([^|]+)|(.+)$")
					local space_id = tonumber(space_str)

					if space_id and app_name and app_name ~= "null" then
						app_name = trim(app_name)
						if not apps_by_space[space_id] then
							apps_by_space[space_id] = {}
						end

						local already_added = false
						for _, existing_app in ipairs(apps_by_space[space_id]) do
							if existing_app.name == app_name then
								already_added = true
								if has_focus == "true" then
									existing_app.focus = true
								end
								break
							end
						end

						if not already_added then
							table.insert(apps_by_space[space_id], {
								name = app_name,
								focus = (has_focus == "true"),
							})
						end
					end
				end

				for space_id = 1, MAX_SPACES do
					for app_index = 1, MAX_APPS_PER_SPACE do
						app_slots[space_id][app_index]:set({ drawing = false })
					end

					if active_spaces[space_id] and apps_by_space[space_id] then
						for app_index, app in ipairs(apps_by_space[space_id]) do
							if app_index <= MAX_APPS_PER_SPACE then
								local slot = app_slots[space_id][app_index]
								local glyph = app_icons[app.name] or app_icons.Default or "—"

								slot:set({
									drawing = true,
									icon = {
										string = glyph,
										font = app.focus and app_icon_size_medium or app_icon_size_small,
										color = app.focus and colors.blue or colors.grey,
									},
								})
							end
						end
					end
				end
			end)
		end)
	end)
end

sbar.add("item", "yabai.event_listener", { drawing = false }):subscribe({
	"yabai_refresh",
	"front_app_switched",
	"space_change",
	"window_created",
	"window_destroyed",
	"window_minimized",
	"window_deminimized",
}, refresh_workspace)

refresh_workspace()
