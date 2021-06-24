local json = require "json"

local path, Runtime = system.pathForFile, Runtime

local M = {}

local defaultFilepath = path ("assets/settings-default.json", system.ResourceDirectory)
local userFilepath = path ("settings-user.json", system.DocumentsDirectory)

local default
local user

local isChanged = false

function M.load ()
    default = json.decodeFile (defaultFilepath)
    user = setmetatable (
        userFilepath and json.decodeFile (userFilepath) or {},
        {__index=default}
    )
end

function M.save ()
    if isChanged and user then
        local file = io.open (userFilepath, 'w')
        file:write (json.encode (user))
        io.close (file)
        isChanged = false
    end
end

function M.get (category, key)
    return user[category][key]
end

function M.set (category, key, value)
    if user[category] == nil and value ~= nil then
        user[category] = {}
        isChanged = true
    end
    isChanged = isChanged or (user[key] == value)
    user[key] = value
end

function M.reset (category, key)
    isChanged = user[category][key] ~= nil
    user[category][key] = nil
    if not user[category] then
        user[category] = nil
    end
end

function M.resetAll ()
    isChanged = next (user) ~= nil
    user = {}
end

M.load ()

-- in case the first launch must be recognized
-- function onSystem (event)
--     if event.type == "applicationExit" and defualt.app.isFirstLaunch then
--         default.app.isFirstLaunch = false
--         file = io.open (defaultPath, 'w')
--         file:write (json.encode (default))
--         io.close (file)
--     end
-- end
-- Runtime:addEventListener ("system")

return M