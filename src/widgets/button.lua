--[[-- -------------------------------------
-- This is the test widget
-- -------------------------------------



-- --= ==-----------------------------------== =--
-- --= =-- local alias of global variables --= =--
local display = display
-- --= ==-----------------------------------== =--



-- --= ==------------------------------== =--
-- --= =-- importing required modules --= =--
local theme = require "src.theme"
local widgets = require "src.widgets"
-- --= ==------------------------------== =--



-- --= ==----------------== =--
-- --= =-- module setup --= =--
local Button = {}
local metatable = {__index=Button}
-- --= ==----------------== =--



-- --= ==-------------------------== =--
-- --= =-- common object methods --= =--
function Button.show (self, args)
    -- play show animation
end

function Button.hide (self, args)
    -- play hide animation
end

function Button.recolor (self)
    -- refill all the widget's components with colors of 'theme'
    -- Note that this method is used to initially color the instance
end

function Button.destroy (self)
    -- completely remove the object
    -- remove all the components of the instance here
    self.background:removeEventListener ("tap", self.callback)
    display.remove (self.background)
    self.background = nil

    -- usually you don't need to touch this
    display.remove (self.group)
    self.group = nil
    widgets.forget (self)
end
-- --= ==-------------------------== =--



-- -= ==-------------------------== =-
-- -= =-- custom object methods --= =-

-- -= ==-------------------------== =-



-- --= ==----------------------== =--
-- --= =-- object constructor --= =--
local function new (index, parent, args)
    -- @pre-init
    local self = setmetatable ({}, metatable)
    self.index = index
    self.group = display.newGroup ()
    parent:insert (self.group)
    if args.anchorX ~= nil then self.group.anchorX = args.anchorX end
    if args.anchorY ~= nil then self.group.anchorY = args.anchorY end
    if args.x ~= nil then self.group.x = args.x end
    if args.y ~= nil then self.group.y = args.y end

    -- @init

    self.background = display.newImage (self.group, args.image)
    local callback = args.callback
    function self.callback (event)
        if event.phase == "ended" then
            callback ()
        end
    end
    self.background:addEventListener ("touch", self.callback)

    -- @post-init
    self:recolor ()
    -- self:show ()
    return self
end
-- --= ==----------------------== =--



return setmetatable (Button, {__call = new})--]]

local Button = {}

function Button.init (self, args)
    self.group.x = args.x
    self.group.y = args.y

    self.callback = args.callback
    -- local imagePath = system.pathForFile ("assets\\" .. args.image, system.ResourceDirectory)
    -- print ("imagePath: ", imagePath)
    self.background = display.newImage (self.group, args.image)
    self.background:addEventListener ("tap", self.callback)
    self.group.alpha = 0
end

function Button.destroy (self)
    self.background:removeEventListener ("tap", self.callback)
    display.remove (self.background)
    self.background = nil
end

function Button.show (self)
    self.group.isVisible = true
    transition.to (self.group, {time=Button.config.showAnimationDuration, alpha=1})
end

return Button