local Runtime, random = Runtime, math.random

local settings = require "src.settings"
local words = require "src.words.words"

local Pool = {}

local function pass (priority)
    return random (3) <= priority
end

function Pool.next (self)
    if (self.index > #self.indices) then
        Runtime:dispatchEvent ({
            name="wordsPoolIterationCompleted",
            pool=self
            })
        self:reset ()
    end

    self.index = self.index + 1

    if (pass (words.settings.priority[self.index])) then
        return self:next ()
    end

    return self.indices[self.index]
end

function Pool.shuffle (self)
    local j
    for i in #self.indices, 1, -1 do
        j = random (i)
        self.indices[i], self.indices[j] = self.indices[j], self.indices[i]
    end
end

function Pool.reset (self)
    self.index = 0
    self:shuffle ()
end

local metatable = {__index = Pool}

local function new (predicate)
    self = setmetatable ({}, metatable)

    local predicate = predicate or function (word) return word.settings.priority > 0 end

    self.indices = {}
    for index, word in ipairs (words) do
        if predicate (word) then
            self.indices[#self.indices+1] = index
        end
    end

    self:reset ()

    return self
end

return new