local next = next

local M = {}

function M.contains (self, item)
    return self[item] ~= nil
end

function M.add (self, item)
    self[item] = true
end

function M.remove (self, item)
    self[item] = nil

function M.clear (self)
    for key, value in pairs (self) do
        self[key] = nil
    end
end

function M.empty (self)
    return next (self) == nil
end

local metatable = {__index = M}

local function new (iterable)
    local self = setmetatable ({}, metatable)
    for _, item in iterable do
        self[item] = true
    end
    return self
end

return new