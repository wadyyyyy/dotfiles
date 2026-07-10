local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local app_font = "sketchybar-app-font:Regular:" .. settings.font_sizes.app

sbar.add("event", "aerospace_refresh")
sbar.add("event", "aerospace_mode_change")

local aerospace_ws = sbar.add("item", "aerospace.ws", {
	icon = {
		font = settings.label_font,
		padding_left = 10,
		padding_right = 0,
		color = colors.white,
	},
	label = { drawing = false },
	padding_left = 1,
})

local aerospace_apps = sbar.add("item", "aerospace.apps", {
	icon = {
		font = app_font,
		color = colors.white,
		padding_right = 2,
		drawing = false,
	},
	label = {
		font = app_font,
		color = colors.grey,
		padding_right = 10,
		y_offset = -1,
	},
	padding_right = 1,
})

sbar.add("bracket", { aerospace_ws.name, aerospace_apps.name }, {
	background = colors.island,
})

aerospace_ws:subscribe({ "aerospace_refresh", "front_app_switched", "aerospace_mode_change" }, function(env)
	local ws = env.FOCUSED_WORKSPACE
	local function updateWorkspace(workspaceId)
		if not workspaceId or workspaceId == "" then
			return
		end
		sbar.exec(
			"/opt/homebrew/bin/aerospace list-windows --workspace " .. workspaceId .. " --format '%{app-name}'",
			function(apps_output)
				sbar.exec(
					"/opt/homebrew/bin/aerospace list-windows --focused --format '%{app-name}|%{workspace}'",
					function(focused_output)
						local focused_app, focused_ws = string.match(focused_output, "^([^|]+)|([^|\r\n]+)")

						if focused_app then
							focused_app = focused_app:gsub("^%s*(.-)%s*$", "%1")
						end
						if focused_ws then
							focused_ws = focused_ws:gsub("^%s*(.-)%s*$", "%1")
						end

						local active_icon = ""
						local rest_icons = ""
						local seen = {}

						for app in string.gmatch(apps_output, "[^\r\n]+") do
							local trimmed_app = app:gsub("^%s*(.-)%s*$", "%1")
							if trimmed_app ~= "" and not seen[trimmed_app] then
								seen[trimmed_app] = true
								local glyph = app_icons[trimmed_app] or app_icons["Default"] or "—"
								if trimmed_app == focused_app and focused_ws == workspaceId then
									active_icon = glyph
								else
									rest_icons = rest_icons .. glyph
								end
							end
						end

						if active_icon == "" and rest_icons == "" then
							rest_icons = " —"
						end

						sbar.exec("/opt/homebrew/bin/aerospace list-modes --current", function(mode_output)
							local mode = mode_output:gsub("^%s*(.-)%s*$", "%1")
							local ws_icon = workspaceId
							local extra_pad = 0
							if mode == "service" then
								ws_icon = workspaceId .. "[S]"
								extra_pad = 4
							end

							aerospace_ws:set({
								icon = ws_icon,
								padding_right = 1 + extra_pad,
							})

							local icon_pad = (rest_icons == "") and 10 or 2

							if active_icon ~= "" then
								aerospace_apps:set({
									icon = { string = active_icon, drawing = true, padding_right = icon_pad },
									label = { string = rest_icons, drawing = rest_icons ~= "" },
								})
							else
								aerospace_apps:set({
									icon = { drawing = false, padding_right = 2 },
									label = { string = rest_icons, drawing = true },
								})
							end
						end)
					end
				)
			end
		)
	end

	if not ws or ws == "" then
		sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(focused_ws)
			ws = focused_ws:gsub("^%s*(.-)%s*$", "%1")
			updateWorkspace(ws)
		end)
	else
		updateWorkspace(ws)
	end
end)

sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(focused_ws)
	local ws = focused_ws:gsub("^%s*(.-)%s*$", "%1")
	if ws and ws ~= "" then
		sbar.trigger("aerospace_refresh", { FOCUSED_WORKSPACE = ws })
	end
end)
