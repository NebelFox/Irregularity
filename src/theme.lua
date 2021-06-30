local Runtime, sub = Runtime, string.sub

local json = require "json"


local theme = {}

local filepath = system.pathForFile ("assets/themes.json", system.ResourceDirectory)

-- local widgets = require "src.widgets"
local settings = require "src.settings"

local themes
local currentThemeIndex = (settings "app.theme")

function theme.init ()
    local hex2rgb = require ("src.utils").convert.hex2rgb
    themes = json.decodeFile (filepath)
    for _, theme in ipairs (themes) do
        for key, value in pairs (theme) do
            theme[key] = hex2rgb (value)
        end
    end
end

function theme.next ()
    currentThemeIndex = currentThemeIndex + 1
    if currentThemeIndex > #themes then
        currentThemeIndex = 1
    end
    settings.set ("app.theme", currentThemeIndex)
end

function theme.previous ()
    currentThemeIndex = currentThemeIndex - 1
    if currentThemeIndex < 1 then
        currentThemeIndex = #themes
    end
    settings.set ("app.theme", currentThemeIndex)
end

-- theme.load ()
-- display.setDefault ("background", unpack (themes[currentThemeIndex].background))

return setmetatable (theme, {__index=function (self, key)
    return themes[currentThemeIndex][key]
end})