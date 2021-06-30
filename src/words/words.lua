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

function words.randomForm ()
    return words.random ().forms[random(3)]
end

function words.sorted (key, reverse)
    local indices = {}
    for key in pairs (data) do
        table.insert (indices, key)
    end
    if reverse then
        table.sort (indices, function (left, right) return key(words[left]) > key(words[right]) end)
    else
        table.sort (indices, function (left, right) return key (words[left]) < key (words[right]) end)
    end
    return indices
end

words.key = {}
function key.priority (word)
    return word.priority
end
function key.permanentAccuracy (word)
    return word["answers.permanent"]:ratio ()
end
function key.weeklyAccuracy (word)
    return word["answers.weekly"]:ratio ()
end

return setmetatable (words, {__index=function (self, key) return data[key] end})