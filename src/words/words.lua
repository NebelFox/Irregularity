local json = require "json"

local random = math.random
local pathForFile, ResourceDirectory = system.pathForFile, system.ResourceDirectory

local settings = require "settings"

local M = {}

local data

function M.load ()
    local path = pathForFile ("assets/words.json", ResourceDirectory)
    if path then
        data = json.decodeFile (path)
    else
        os.exit ()
    end
end

function M.save ()

end

function M.random ()
    return data[random (#data)]
end

M.word = {}
M.word = setmetatable (M.word, {__index = function (index) return data[index].word end})
M.word.meaning = setmetatable ({}, {__index = function (index) return data[index].meaning end})
M.word.forms = setmetatable ({}, {__index = function (index) return data[index].forms end})
function M.word.random ()
    return data[random (#data)].word
end
function M.word.forms.random ()
    return M.word.random ().forms[random (3)]
end

-- settings
M.settings = setmetatable (
    {
        priority = setmetatable (
            {},
            {__index=function (index)
                local priority = data[index].settings.priority
                if (settings.overrideWithGlobalValue.priority or priority == nil) then
                    return settings.globals.priority
                else
                    return priority
                end
            end}
        ),
        isPriorityLocked = setmetatable (
            {},
            {__index=function (index)
                local state = data[index].settings.isPriorityLocked
                if (settings.overrideWithGlobalValue.isPriorityLocked or state == nil) then
                    return settings.globals.isPriorityLocked
                else
                    return state
                end
            end}
        )
    },
    {__index = function (index) return data[index].settings end}
)

-- statistics
M.statistics = setmetatable ({}, {__index=function (index) return data[index].statistics end})

return setmetatable (M, {__index=data})