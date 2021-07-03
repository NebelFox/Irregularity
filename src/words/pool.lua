local Runtime, random = Runtime, math.random

local settings = require "src.settings"
local words = require "src.words.words"
local utils = require "src.utils"

local Pool = {}

function Pool.next (self)
    if (self.index > #self.indices) then
        Runtime:dispatchEvent ({
            name="wordsPoolIterationCompleted",
            pool=self
            })
        self:reset ()
    end

    self.index = self.index + 1

    if (words[self.index].answers:priority () > random ()) then
        return self:next ()
    else
        return self.indices[self.index]
    end
end

function Pool.shuffle (self)
    local j
    for i=#self.indices, 1, -1 do
        j = random (i)
        self.indices[i], self.indices[j] = self.indices[j], self.indices[i]
    end
end

function Pool.reset (self)
    self.index = 0
    self:shuffle ()
end

function Pool.init (self, args)
    self.indices = utils.indices (words.count ())
    for i=1, words.count () do
        indices[i] = i
    end

    self:reset ()
end

return utils.class (Pool)