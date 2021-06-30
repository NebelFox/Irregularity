-- --------------------------------------
-- This is the template of a widget class
-- Don't forget to add this filename into
-- assets/widgets-config.json -----------
-- --------------------------------------

-- local alias of global variables
local display = display

-- required packages
local theme = require "src.theme"
local widgets = require "src.widgets"

-- widget class
local Placeholder = {}

-- common widget methods overriding
-- avaliable methods: init, show, hide, showhide, recolor, destroy
function Placeholder.init (self, args)
    -- self.group.x = args.x
    -- self.group.y = args.y
    -- self.group.anchorX = args.anchorX or self.group.anchorX
    -- self.group.anchorY = args.anchorY or self.group.anchorY
end
function Placeholder.show (self)
    -- play show animation
end
function Placeholder.hide (self)
    -- play hide animation
end
function Placeholder.recolor (self)
    -- refill all the widget's components with colors of 'theme'
    -- Note that this method is used to initially color the instance
end
function M.destroy (self)
    -- completely remove the object
    -- remove all the components of the instance here
end

-- custom widget methods

return Placeholder