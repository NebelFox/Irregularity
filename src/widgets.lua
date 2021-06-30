-- globals aliases
local require, unpack, table, display, string = require, unpack, table, display, string
local delay = timer.performWithDelay

-- required modules
local json = require "json"
local composer = require "composer"
local settings = require "src.settings"
local theme = require "src.theme"
local utils = require "src.utils"

-- setup file
local configs = json.decodeFile (system.pathForFile ("assets/widgets-config.json", system.ResourceDirectory))

-- module table
local widgets = {}

-- group to add widgets into
local group = display.getCurrentStage ()

-- registered widget classes
local components = {}

-- all currently living widgets
local instances = {}

-- starts tracking the instance
function widgets.register (instance)
    table.insert (instances, instance)
    group:insert (instance.group)
    -- for easy deletion from the instances
    instance._index = #instances
end

-- registers all the components
-- from the linked file
function widgets.init ()
    local Widget = require "src.widgets.widget"
    for filename, config in pairs (configs) do
        components[utils.convert.snake2pascal (filename)] = Widget (
            require ("src.widgets." .. filename),
            config
        )
    end
    widgets.Background ()
    widgets.guard = widgets.TouchGuard ()
end

-- recolors all the widgets and background
-- according to the current theme
function widgets.recolor ()
    for _, instance in pairs (instances) do
        instance:recolor ()
    end
end

-- hides all the widgets
function widgets.hideAll (doDestroyOnComplete)
    for _, instance in pairs (instances) do
        instance:hide (doDestroyOnComplete)
    end
end

-- removes a widget instance from the tracking list,
-- so it can be collected with GC
function widgets.forget (instance)
    table.remove (instances, instance._index)
end

-- destroys all the instances of widgets
function widgets.destroyAll ()
    for _, instance in ipairs (instances) do
        instance:destroy ()
    end
end

-- automates the widgets.recolor ()
local function onSettingChanged (key, value)
    if key == "app.theme" then widgets.recolor () end
end
settings.subscribe (onSettingChanged)

-- function widgets.animation (duration)

-- end

return setmetatable (widgets, {__index=components})