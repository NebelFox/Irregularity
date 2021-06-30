local sub = string.sub

local theme = require "src.theme"

local utils = {}

-- converters
utils.convert = {}
function utils.convert.snake2pascal (s)
    return string.gsub (s, "(%a)([%w]*)_*", function (a, b) return string.upper (a) .. b end)
end

function utils.convert.hex2rgb (hex)
    local rgb = {}
    for i = 1, 3 do
        rgb[i] = tonumber ("0x"..sub (hex, i*2-1, i*2)) / 255
    end
    return rgb
end

-- coloring shorthands
utils.color = {}
function utils.color.fill (object, colorkey)
    object:setFillColor (unpack (theme[colorkey]))
end
function utils.color.stroke (object, colorkey)
    object:setStrokeColor (unpack (theme[colorkey]))
end
function utils.color.background (colorkey)
    display.setDefault ("background", unpack (theme[colorkey]))
end

-- misc
function utils.inside (object, x, y)
    local bounds = object.contentBounds
    return x <= bounds.xMax and x >= bounds.xMin and y <= bounds.yMax and y >= bounds.yMin
end

function utils.class (template)
    return setmetatable ({}, {
        __call = function (class, args)
            local args = args or {}
            local self = setmetatable ({}, template)
            template.init (self, args)
            return self
        end,
        __index = template
    })
end

return utils