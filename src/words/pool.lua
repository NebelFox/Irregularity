local Runtime, random = Runtime, math.random

local settings = require "src.settings"
local words = require "src.words.words"
local utils = require "src.utils"

local Pool = {}
-- local metatable = {__index = M}

local function pass (ratio)
    return (1-ratio)*0.9 > random ()
end

function Pool.next (self)
    if (self.index > #self.indices) then
        Runtime:dispatchEvent ({
            name="wordsPoolIterationCompleted",
            M=self
            })
        self:reset ()
    end

    self.index = self.index + 1

    if (pass (words.answers:ratio ())) then
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

function Pool.init (self, args)
    self.indices = {}
    for index, word in ipairs (words) do
        self.indices[#self.indices+1] = index
    end

    self:reset ()
end

return utils.class (Pool)