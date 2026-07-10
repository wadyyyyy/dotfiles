-- Register the event in Sketchybar synchronously so it's ready for subscription
os.execute("sketchybar --add event input_change 'AppleSelectedInputSourcesChangedNotification' 2>/dev/null || true")

local colors = require("colors")
local settings = require("settings")

local keyboard = sbar.add("item", "widgets.keyboard", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "??",
		font = settings.label_font,
		align = "left",
		padding_left = 6,
		padding_right = 6,
		width = "dynamic",
	},
})

sbar.add("bracket", "widgets.keyboard.bracket", { keyboard.name }, {
	background = colors.island,
})

sbar.add("item", "widgets.keyboard.padding", {
	position = "right",
	width = settings.group_paddings,
})

local layout_script = [[
defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null | grep -w "KeyboardLayout Name" | cut -d "=" -f 2 | tr -d '"; '
]]

local function normalize_layout(raw)
	if not raw or raw == "" then
		return "??"
	end
	raw = raw:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace

	-- Common simple mappings:
	if raw == "Russian" or raw == "RussianWin" then
		return "RU"
	end
	if raw == "ABC" or raw == "U.S." or raw == "US" then
		return "EN"
	end

	return string.sub(raw:upper(), 1, 2)
end

local function update_layout()
	sbar.exec(layout_script, function(result)
		local label = normalize_layout(result)
		keyboard:set({ label = label })
	end)
end

keyboard:subscribe({ "input_change", "system_woke" }, update_layout)

-- Trigger an initial update immediately
update_layout()
