local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Укажи правильные пути к бинарникам, если они отличаются
local yabai_bin = "/opt/homebrew/bin/yabai"
local jq_bin = "/opt/homebrew/bin/jq"

local app_icon_size_medium = "sketchybar-app-font:Regular:" .. settings.sizes.icon_medium
local app_icon_size_small = "sketchybar-app-font:Regular:" .. settings.sizes.icon_small

local MAX_INACTIVE_SLOTS = 10

local function trim(value)
	return value and value:gsub("^%s*(.-)%s*$", "%1") or value
end

sbar.add("event", "yabai_refresh")

local yabai_workspace = sbar.add("item", "yabai.ws", {
	position = "left",
	icon = {
		font = settings.label_font,
		color = colors.white,
		align = "center",
	},
	label = { drawing = false },
	padding_left = settings.paddings.edge_padding + settings.paddings.paddings,
	padding_right = settings.paddings.paddings,
})

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

local function render_workspace(workspace_id)
	if not workspace_id or workspace_id == "" or workspace_id == "null" then
		return
	end

	-- Получаем список всех окон на спейсе
	local apps_cmd =
		string.format("%s -m query --windows --space %s | %s -r '.[].app'", yabai_bin, workspace_id, jq_bin)

	sbar.exec(apps_cmd, function(workspace_apps_output)
		-- Получаем активное окно и его спейс
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
				if app_name ~= "null" then -- игнорируем пустые ответы от jq
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

			yabai_workspace:set({
				icon = { string = workspace_id },
			})

			yabai_active:set({
				icon = {
					string = active_icon,
					drawing = (active_icon ~= ""),
				},
			})
		end)
	end)
end

local function refresh_workspace(env)
	local workspace_id = env.FOCUSED_WORKSPACE
	if workspace_id and workspace_id ~= "" then
		render_workspace(workspace_id)
		return
	end

	-- Если env пустой, запрашиваем текущий рабочий стол
	local space_cmd = string.format("%s -m query --spaces --space | %s -r '.index'", yabai_bin, jq_bin)
	sbar.exec(space_cmd, function(focused_workspace_output)
		render_workspace(trim(focused_workspace_output))
	end)
end

-- Подписка на нативные и кастомные события
yabai_workspace:subscribe({ "yabai_refresh", "front_app_switched", "space_change" }, refresh_workspace)

-- Триггер при загрузке
refresh_workspace({})
