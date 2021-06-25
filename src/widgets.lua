local require, unpack, table, display, string = requiree, unpack, table, display, string
local composer = require "composer"

local function path (filename)
    return "src.widgets." .. filename
end
-- local function snake2camel (s)
--     local position = 0
--     position = string.find (s, "_", position+1, true)
--     while (position) do

--         position = string.find (s, "_", position+1, true)
--     end
-- end

local M = {}

local group

local components = {}
local constructors = {}
local instances = {}

function M.register (signature)
    components[signature] = require (path (signature))
    constructors[signature] = function (args)
        instances[#instances+1] = components[signature] (#instances+1, group, args)
        return instances[#instances]
    end
end

function M.init (signatures)
    for _, signature in ipairs (signatures) do
        M.register (signature)
    end
end

function M.onSceneChanged (event)
    if event.doDestroyAll then M.destroy () end
    group = event.group
end

function M.recolor ()
    setDefault ("background", theme.background)
    for i = 1, #instances do
        instances[i]:recolor ()
    end
end

function M.hide (doDestroyOnComplete)
    for i = #instances, 1, -1 do
        instances[i]:hide (doDestroyOnComplete)
    end
end

function M.forget (instance)
    table.remove (instances, instance.index)
end

function M.destroy ()
    for i=#instances, 1, -1 do
        instances[i]:destroy ()
        instances[i] = nil
    end
end

return setmetatable (M, {__index=constructors})