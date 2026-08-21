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
	bracket_padding = 1,
	space = {
		padding_left = 6, -- gap after space name to edge of it's container
		padding_right = 6,
		gap = settings.paddings.group_padding - 4, -- gap between space's containers
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

		-- corner_radius = 0,
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
		sbar.exec(aerospace_bin .. " list-workspaces --focused", function(out)
			local focused = trim(out)
			for _, ws in ipairs(WORKSPACES) do
				space_items[ws]:set({
					icon = {
						string = ws,
						color = ws == focused and colors.blue or colors.white,
					},
				})
			end

			refresh_apps(focused)
		end)
	end)
end

local function refresh_apps(focused)
	sbar.exec(
		string.format("%s list-windows --workspace '%s' --format '%%{app-name}'", aerospace_bin, focused),
		function(out)
			local apps = {}

			for line in string.gmatch(out, "[^\r\n]+") do
				local app = trim(line)

				if not ignored_apps[app] then
					local exists = false

					for _, v in ipairs(apps) do
						if v.name == app then
							exists = true
							break
						end
					end

					if not exists then
						table.insert(apps, {
							name = app,
							focus = false,
						})
					end
				end
			end

			sbar.exec(aerospace_bin .. " list-windows --focused --format '%{app-name}'", function(active)
				active = trim(active)

				for _, app in ipairs(apps) do
					if app.name == active then
						app.focus = true
					end
				end

				for i = 1, MAX_APPS do
					local app = apps[i]

					if app then
						local glyph = app_icons[app.name] or app_icons.Default or "—"

						app_slots[i]:set({
							drawing = true,
							icon = {
								string = glyph,
								font = app.focus and app_icon_size_medium or app_icon_size_small,

								color = app.focus and colors.blue or colors.grey,
							},
						})
					else
						app_slots[i]:set({
							drawing = false,
						})
					end
				end
			end)
		end
	)
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
