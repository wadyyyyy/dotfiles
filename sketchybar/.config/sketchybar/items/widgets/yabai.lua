local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local yabai_bin = "/opt/homebrew/bin/yabai"
local jq_bin = "/opt/homebrew/bin/jq"

local app_icon_size_medium = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium
local app_icon_size_small = "sketchybar-app-font:Regular:" .. settings.sizes.icon_small

local MAX_SPACES = 10
local MAX_APPS = 7

local y_cfg = {
	bracket_padding = 0,
	space = {
		padding_left = 6,
		padding_right = 6,
		gap = settings.paddings.group_padding,
	},
	apps = {
		gap = settings.paddings.paddings,
	},
}

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or value
end

sbar.add("event", "yabai_refresh")

sbar.add("item", "another_edge_padding", {
	position = "left",
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = settings.paddings.edge_padding,
})

local space_items = {}
local spaces_bracket_items = {}

local bracket_left_pad = sbar.add("item", "yabai.bracket.padding.left", {
	position = "left",
	width = y_cfg.bracket_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = 0,
	padding_right = 0,
})
table.insert(spaces_bracket_items, "yabai.bracket.padding.left")

for space_id = 1, MAX_SPACES do
	local space_name = "yabai.space." .. space_id

	space_items[space_id] = sbar.add("item", space_name, {
		position = "left",
		icon = {
			font = settings.label_font,
			color = colors.white,
			align = "center",
			padding_left = y_cfg.space.padding_left,
			padding_right = y_cfg.space.padding_right,
		},
		background = {
			height = settings.ui.container.nesting_height,
			color = colors.container.nesting_bg,
			corner_radius = settings.ui.container.nesting_corner_radius,
			border_color = colors.container.nesting_border_color,
			border_width = settings.ui.background.border_width + 1,
		},
		label = { drawing = false },
		drawing = false,
		padding_left = y_cfg.space.gap,
		padding_right = 0,
	})
	table.insert(spaces_bracket_items, space_name)
end

local bracket_right_pad = sbar.add("item", "yabai.bracket.padding.right", {
	position = "left",
	width = y_cfg.bracket_padding,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
	padding_left = y_cfg.space.gap,
	padding_right = 0,
})
table.insert(spaces_bracket_items, "yabai.bracket.padding.right")

sbar.add("bracket", "yabai.bracket", spaces_bracket_items, {
	background = {
		color = colors.container.bg,
		height = settings.ui.container.height,
		border_color = colors.container.border_color,
		border_width = settings.ui.container.border_width,
		corner_radius = settings.ui.container.corner_radius,
		y_offset = settings.ui.container.y_offset,
	},
})

sbar.add("item", "yabai.spacer", {
	position = "left",
	width = settings.paddings.paddings + 4,
	drawing = true,
	icon = { drawing = false },
	label = { drawing = false },
})

local app_slots = {}
for app_index = 1, MAX_APPS do
	local app_name = "yabai.app." .. app_index
	app_slots[app_index] = sbar.add("item", app_name, {
		position = "left",
		icon = { align = "center" },
		label = { drawing = false },
		drawing = false,
		padding_left = (app_index == 1) and 0 or y_cfg.apps.gap,
		padding_right = 0,
	})
end

local ignored_apps = {
	[""] = true,
	["Control Center"] = true,
	["Window Server"] = true,
	["WindowManager"] = true,
	["Spotlight"] = true,
	["SystemUIServer"] = true,
}

local function refresh_workspace()
	sbar.delay(0.05, function()
		local spaces_cmd = string.format(
			'%s -m query --spaces | %s -r \'.[] | "\\(.index)|\\(.["has-focus"])|\\(.label)"\'',
			yabai_bin,
			jq_bin
		)

		sbar.exec(spaces_cmd, function(spaces_output)
			local active_spaces = {}
			local space_labels = {}

			for line in string.gmatch(spaces_output, "[^\r\n]+") do
				local index_str, has_focus, label = string.match(line, "^([^|]+)|([^|]+)|(.*)$")
				local index = tonumber(index_str)

				if index then
					active_spaces[index] = true
					local display_label = (label and label ~= "" and label ~= "null") and label or index_str
					space_labels[index] = { label = display_label, focus = (has_focus == "true") }
				end
			end

			for space_id = 1, MAX_SPACES do
				if active_spaces[space_id] then
					local s_info = space_labels[space_id]
					space_items[space_id]:set({
						drawing = true,
						icon = {
							string = s_info.label,
							color = s_info.focus and colors.blue or colors.white,
						},
					})
				else
					space_items[space_id]:set({ drawing = false })
				end
			end

			local windows_cmd = string.format(
				'%s -m query --windows | %s -r \'.[]? | select(."is-visible" == true and .subrole == "AXStandardWindow") | "\\(.space)|\\(.["has-focus"])|\\(.app)"\'',
				yabai_bin,
				jq_bin
			)

			sbar.exec(windows_cmd, function(windows_output)
				local current_visible_apps = {}

				for line in string.gmatch(windows_output, "[^\r\n]+") do
					local space_str, has_focus, app_name = string.match(line, "^([^|]+)|([^|]+)|(.+)$")
					app_name = trim(app_name or "")

					if app_name ~= "" and app_name ~= "null" and not ignored_apps[app_name] then
						local already_added = false
						for _, existing_app in ipairs(current_visible_apps) do
							if existing_app.name == app_name then
								already_added = true
								if has_focus == "true" then
									existing_app.focus = true
								end
								break
							end
						end

						if not already_added then
							table.insert(current_visible_apps, {
								name = app_name,
								focus = (has_focus == "true"),
							})
						end
					end
				end

				for i = 1, MAX_APPS do
					local app = current_visible_apps[i]
					local slot = app_slots[i]

					if app then
						local glyph = app_icons[app.name] or app_icons.Default or "—"
						slot:set({
							drawing = true,
							icon = {
								string = glyph,
								font = app.focus and app_icon_size_medium or app_icon_size_small,
								color = app.focus and colors.blue or colors.grey,
							},
						})
					else
						slot:set({ drawing = false })
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
