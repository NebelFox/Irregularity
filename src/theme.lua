local Runtime, sub = Runtime, string.sub

local json = require "json"

local M = {}

local filepath = system.PathForFile ("assets/themes.json", system.ResourceDirectory)

local settings = require "src.settings"

local themes
local currentThemeIndex

local function hex2rgb (hex)
    local rgb = {}
    for i = 1, 3 do
        rgb[i] = tonumber ("0x"..sub (hex, i + (i-1)*2, i*3 - 1)) / 255
    end
    return rgb
end

function M.load ()
    themes = json.decodeFile (filepath)
    for _, theme in ipairs (themes) do
        for key, value in pairs (theme) do
            value[key] = hex2rgb (value)
        end
    end
end

function M.update ()
    currentThemeIndex = settings.app.theme
end

M.load ()
M.update ()

Runtime:addEventListener ("settingsChanged", function (event)
    if event.category == "app" and event.key == "theme" then
        M.update ()
    end
end)

return setmetatable (M, {__index=function (self, key)
    return unpack(themes[currentThemeIndex][key])
end})