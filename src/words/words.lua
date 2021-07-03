local pathForFile, ResourceDirectory = system.pathForFile, system.ResourceDirectory
local random = math.random

local json = require "json"
local settings = require "settings"
local Answers = require "src.words.answers"

local words = {}

local data

function words.load ()
    local path = pathForFile ("assets/words.json", ResourceDirectory)
    if path then
        data = json.decodeFile (path)
        for index, word in ipairs (data) do
            word["answers"] = Answers (word["answers"])
        end
    else
        os.exit ()
    end
end

function words.save ()

end

function words.count ()
    return #data
end

function words.random ()
    return data[random (#data)]
end

function words.randomForm ()
    return words.random ().forms[random(3)]
end

function words.sorted (key, reverse)
    local indices = {}
    for key in pairs (data) do
        table.insert (indices, key)
    end
    if reverse then
        table.sort (indices, function (left, right) return key(data[left]) > key(data[right]) end)
    else
        table.sort (indices, function (left, right) return key (data[left]) < key (data[right]) end)
    end
    return indices
end

return setmetatable (words, {__index=function (self, index) return data[index] end})