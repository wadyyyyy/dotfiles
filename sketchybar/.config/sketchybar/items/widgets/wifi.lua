local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Bold"],
      size = settings.font_sizes.icon_medium,
    },
    padding_left = 8,
    padding_right = 8,
  },
  label = { drawing = false },
})

sbar.add("bracket", "widgets.wifi.bracket", {
  wifi.name,
}, {
  background = colors.island,
})

sbar.add("item", { position = "right", width = settings.group_paddings })

local network_script = [[
  VPN_STATUS="OFF"
  if scutil --nwi | grep -m1 'VPN' >/dev/null; then
    VPN_STATUS="ON"
  fi

  WIFI_POWER=$(networksetup -getairportpower en0 | awk '{print $4}')
  if [ "$WIFI_POWER" = "Off" ]; then
    CONN="OFF"
  else
    SSID=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')
    if [ -n "$SSID" ]; then
      if ipconfig getsummary en0 | grep -qE '^ *sname = [a-zA-Z0-9]'; then
        CONN="HOTSPOT"
      else
        CONN="WIFI"
      fi
    elif [ -n "$(ipconfig getifaddr en0)" ]; then
      CONN="ETHERNET"
    else
      CONN="NO_INTERNET"
    fi
  fi
  echo "${VPN_STATUS}|${CONN}"
]]

local function update_wifi()
  sbar.exec(network_script, function(result)
    result = result:gsub("^%s*(.-)%s*$", "%1")
    local vpn, conn = result:match("([^|]+)|([^|]+)")
    local icon, color

    if conn == "WIFI" then
      icon = (vpn == "ON") and icons.wifi.vpn or icons.wifi.connected
      color = (vpn == "ON") and colors.blue or colors.white
    elseif conn == "HOTSPOT" then
      icon = icons.wifi.hotspot
      color = (vpn == "ON") and colors.blue or colors.white
    elseif conn == "ETHERNET" then
      icon = icons.wifi.ethernet
      color = (vpn == "ON") and colors.blue or colors.white
    elseif conn == "NO_INTERNET" then
      icon = icons.wifi.disconnected
      color = colors.yellow
    else -- OFF
      icon = icons.wifi.disconnected
      color = colors.red
    end

    wifi:set({
      icon = { string = icon, color = color },
    })
  end)
end

wifi:subscribe({ "wifi_change", "system_woke" }, update_wifi)

-- Initial trigger
sbar.exec("sleep 0.1", update_wifi)
