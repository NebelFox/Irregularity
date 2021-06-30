local Background = {}

local theme = require "src.theme"

function Background.recolor (self)
    display.setDefault ("background", unpack (theme.background))
end

return Background