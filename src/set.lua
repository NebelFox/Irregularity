local next, ipairs, pairs = next, ipairs, pairs
local table_copy, table_concat = table.copy, table.concat

local utils = require "src.utils"

local Set = utils.class ()

function Set.size (self)
    local size = 0
    for value in pairs (self.__data) do
        size = size + 1
    end
    return size
end

function Set.contains (self, item)
    return self.__data[item] ~= nil
end

function Set.add (self, item)
    self.__data[item] = true
end

function Set.remove (self, item)
    self.__data[item] = nil
end

function Set.clear (self)
    self.__data = {}
    -- for key, value in pairs (self) do
    --     self.__data[key] = nil
    -- end
end

function Set.empty (self)
    return next (self.__data) == nil
end

function Set.__add (left, right)
    local data = table_copy (left.__data)
    for value in pairs (right.__data) do
        data[value] = true
    end
    return Set {data=data}
end

function Set.__sub (left, right)
    local data = table_copy (left.__data)
    for value in pairs (right.__data) do
        data[value] = nil
    end
    return Set {data=data}
end

function Set.__mul (left, right)
    local data = {}
    for value in pairs (left.__data) do
        data[value] = (right.__data[value] == true)
    end
    return Set {data=data}
end

function Set.__div (left, right)
    local data = table_copy (left.__data)
    for value in pairs (right.__data) do
        data[value] = (data[value] ~= right.__data[value]) and true or nil
    end
    return Set {data=data}
end

function Set.init (self, args)
    self.__data = {}
    if args[1] then
        for _, value in ipairs (args) do
            self.__data[value] = true
        end
    elseif args.table then
        for _, value in ipairs (args) do
            self.__data[value] = true
        end
    elseif args.copy then
        self.__data = table_copy (args.copy.__data)
    elseif args.data then
        self.__data = args.data
    end
end

function Set.toString (self)
    local values = {}
    for value in pairs (self.__data) do
        values[#values+1] = value
    end
    return '{ ' .. table_concat( values, ", ") .. ' }'
end

return Set