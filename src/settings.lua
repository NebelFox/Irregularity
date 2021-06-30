-- required modules
local json = require "json"

-- globals aliases
local path, Runtime, io = system.pathForFile, Runtime, io

-- settings files
local defaultFilepath = path ("assets/settings-default.json", system.ResourceDirectory)
local userFilepath = path ("settings-user.json", system.DocumentsDirectory)

-- module table
local settings = {}

-- settings data
local default
local user

-- whether there is a reason of rewriting the user file
local isChanged = false

-- reactive methods
local subscribers = {}
local function notify (key, value)
    for _, subscriber in ipairs(subscribers) do
        subscriber (key, value)
    end
end
function settings.subscribe (subscriber)
    table.insert (subscribers, subscriber)
end
function settings.unsubscribe (subscriber)
    table.remove (subscribers, table.indexOf (subscribers, subscriber))
end
function settings.unsubscribeAll ()
    subscribers = {}
end

-- io part
function settings.load ()
    default = json.decodeFile (defaultFilepath)
    -- if there is no file or it's content is empty
    user = setmetatable (json.decodeFile (userFilepath) or {}, {__index=default})
end
function settings.save ()
    if isChanged then
        local file = io.open (userFilepath, 'w')
        -- if settings are reset - the file is cleared, so it takes less storage space
        if user then
            file:write (user)
        end
        io.close (file)
        isChanged = false
    end
end

-- reactive setter method
function settings.set (key, value)
    if user[key] ~= value then
        user[key] = value
        isChanged = true
        notify (key, value)
    end
end

-- reactive reset methods
function settings.reset (key)
    isChanged = rawget(user, key) ~= nil
    user[key] = nil
    notify (key, default[key])
end
function settings.resetAll ()
    isChanged = next (user) ~= nil
    for key, value in pairs (user) do
        notify (key, default[key])
    end
    user = setmetatable ({}, {__index=default})
end

settings.load ()

-- preventing changing any values without the settings.set 
return setmetatable (settings, {__call = function (self, key)
    return user[key]
end})