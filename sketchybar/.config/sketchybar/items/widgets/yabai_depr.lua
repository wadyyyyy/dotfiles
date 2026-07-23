local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local yabai_bin = "/opt/homebrew/bin/yabai"
local jq_bin = "/opt/homebrew/bin/jq"

local app_icon_size_medium = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium
local app_icon_size_small = "sketchybar-app-font:Regular:" .. settings.sizes.icon_small

local MAX_SPACES = 15
local MAX_INACTIVE_SLOTS = 10

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or value
end

sbar.add("event", "yabai_refresh")

sbar.add("item", "edge_dadding", {
	position = "left",
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = settings.paddings.edge_padding,
})

local space_items = {}
for i = 1, MAX_SPACES do
	space_items[i] = sbar.add("item", "yabai.space." .. i, {
		position = "left",
		icon = {
			font = settings.label_font,
			string = tostring(i),
			color = colors.white,
			align = "center",
		},
		label = { drawing = false },
		drawing = false,
		padding_left = settings.paddings.paddings,
		padding_right = settings.paddings.paddings,
	})
end

local yabai_active = sbar.add("item", "yabai.active", {
	position = "left",
	icon = {
		font = app_icon_size_medium,
		color = colors.blue,
		align = "center",
	},
	label = { drawing = false },
	padding_left = settings.paddings.paddings,
	padding_right = settings.paddings.paddings,
})

local inactive_slots = {}
for i = 1, MAX_INACTIVE_SLOTS do
	local slot = sbar.add("item", "yabai.inactive." .. i, {
		position = "left",
		icon = { drawing = false },
		label = {
			font = app_icon_size_small,
			color = colors.grey,
			align = "center",
		},
		drawing = false,
		padding_left = settings.paddings.paddings,
		padding_right = settings.paddings.paddings,
	})
	table.insert(inactive_slots, slot)
end

local function reorder_items(visible_spaces_count)
	local last_item = nil

	for i = 1, MAX_SPACES do
		if space_items[i]:query().geometry.drawing == "on" then
			if last_item then
				space_items[i]:move({ after = last_item })
			end
			last_item = "yabai.space." .. i
		end
	end

	if last_item then
		yabai_active:move({ after = last_item })
		last_item = "yabai.active"
	end

	for i, slot in ipairs(inactive_slots) do
		if slot:query().geometry.drawing == "on" then
			if last_item then
				slot:move({ after = last_item })
			end
			last_item = "yabai.inactive." .. i
		end
	end
end

local function render_apps(workspace_id)
	if not workspace_id or workspace_id == "" or workspace_id == "null" then
		return
	end

	local apps_cmd =
		string.format("%s -m query --windows --space %s | %s -r '.[].app'", yabai_bin, workspace_id, jq_bin)

	sbar.exec(apps_cmd, function(workspace_apps_output)
		local focused_cmd = string.format(
			'%s -m query --windows --window | %s -r \'if .app then .app + "|" + (.space|tostring) else "" end\'',
			yabai_bin,
			jq_bin
		)

		sbar.exec(focused_cmd, function(focused_output)
			local focused_app, focused_workspace = string.match(focused_output, "^([^|]+)|([^|\r\n]+)")
			focused_app = trim(focused_app)
			focused_workspace = trim(focused_workspace)

			local active_icon = ""
			local inactive_glyphs = {}
			local seen_apps = {}

			for app_name in string.gmatch(workspace_apps_output, "[^\r\n]+") do
				if app_name ~= "null" then
					local normalized_app_name = trim(app_name)
					if normalized_app_name ~= "" and not seen_apps[normalized_app_name] then
						seen_apps[normalized_app_name] = true
						local glyph = app_icons[normalized_app_name] or app_icons.Default or "—"

						if
							normalized_app_name == focused_app
							and tostring(focused_workspace) == tostring(workspace_id)
						then
							active_icon = glyph
						else
							table.insert(inactive_glyphs, glyph)
						end
					end
				end
			end

			if active_icon == "" and #inactive_glyphs == 0 then
				table.insert(inactive_glyphs, "—")
			end

			for i, slot in ipairs(inactive_slots) do
				local glyph = inactive_glyphs[i]
				if glyph then
					slot:set({
						label = { string = glyph },
						drawing = true,
					})
				else
					slot:set({ drawing = false })
				end
			end

			yabai_active:set({
				icon = {
					string = active_icon,
					drawing = (active_icon ~= ""),
				},
			})

			reorder_items()
		end)
	end)
end

local function refresh_workspace()
	sbar.delay(0.05, function()
		local spaces_cmd = string.format(
			'%s -m query --spaces | %s -r \'.[] | "\\(.index)|\\(.["has-focus"])|\\(.windows | length)"\'',
			yabai_bin,
			jq_bin
		)

		sbar.exec(spaces_cmd, function(spaces_output)
			local active_workspace_id = nil

			for i = 1, MAX_SPACES do
				space_items[i]:set({ drawing = false })
			end

			for line in string.gmatch(spaces_output, "[^\r\n]+") do
				local index_str, has_focus, windows_count_str = string.match(line, "^([^|]+)|([^|]+)|([^|]+)")
				local index = tonumber(index_str)
				local windows_count = tonumber(windows_count_str) or 0

				if index and space_items[index] then
					local is_active = (has_focus == "true")
					local has_windows = windows_count > 0

					if is_active then
						active_workspace_id = index_str
					end

					space_items[index]:set({
						icon = {
							color = is_active and colors.blue or colors.white,
						},
						drawing = is_active or has_windows,
					})
				end
			end

			if active_workspace_id then
				render_apps(active_workspace_id)
			end
		end)
	end)
end

sbar.add("item", "yabai.event_listener", { drawing = false })
	:subscribe({ "yabai_refresh", "front_app_switched", "space_change" }, refresh_workspace)

refresh_workspace()
