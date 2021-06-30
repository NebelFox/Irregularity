local next = next

local utils = require "src.utils"

local Set = {}

function Set.contains (self, item)
    return self[item] ~= nil
end

function Set.add (self, item)
    self[item] = true
end

function Set.remove (self, item)
    self[item] = nil

function Set.clear (self)
    for key, value in pairs (self) do
        self[key] = nil
    end
end

function Set.empty (self)
    return next (self) == nil
end

-- local metatable = {__index = M}

function Set.init (self, args)
    -- local self = setmetatable ({}, metatable)
    for _, item in pairs(iterable) do
        self[item] = true
    end
    -- return self
end

return utils.class (Set)