-- local alias of global variables
local display = display

-- required packages
local theme = require "src.theme"
local utils = require "src.utils"

-- widget class
local Key = {}

-- common widget methods overriding
-- methods: init, show, hide, showhide, recolor, destroy
function Key.init (self, args)
    self.group.anchorX = 0
    self.group.anchorY = 1
    self.group.x = args.x
    self.group.y = args.y
    self.key = args.key
    self.lifespan = args.lifespan or 0
    self.background = display.newRoundedRect (self.group, 0, 0, self.parent.keyWidth, self.parent.keyHeight, math.min (self.parent.keyWidth, self.parent.keyHeight) * 0.35 )
    self.background.strokeWidth = 3
    self.label = display.newText (
        self.group,
        self.key,
        0,
        0,
        native.systemFont,
        40)
    self.background:addEventListener ("touch", self)
end

function Key.recolor (self)
    -- refill all the widget's components with colors of 'theme'
    -- Note that this method is used to initially color the instance
    utils.color.fill (self.background, self.isFocus and "background" or "foreground")
    utils.color.stroke (self.background, self.isFocus and "foreground" or "background")
    utils.color.fill (self.label, self.isFocus and "foreground" or "background")
end

function Key.destroy (self)
    -- completely remove the object
    -- remove all the components of the instance here
    self.background:removeEventListener ("touch", self.listener)
    display.remove (self.background)
    self.background = nil
    display.remove (self.label)
    self.label = nil
end

-- custom widget methods
function Key.use (self)
    self.lifespan = self.lifespan - 1
    if self.lifespan == 0 then
        self.parent:forget (self)
        self:destroy ()
    end
end

function Key.press (self, phase)
    self.parent:press (self.key, phase)
end

function Key.touch (self, event)
    if event.phase == "began" then
        display.getCurrentStage ():setFocus (self.background)
        self.isFocus = true
        self:press ("down")
    elseif event.phase == "ended" then
        display.getCurrentStage ():setFocus (nil)
        self.isFocus = false
        self:press (utils.inside (self.background, event.x, event.y) and "up" or "canceled")
    end
end

function Key.color (self, background, foreground)
    if background then utils.color.fill (self.background, background) end
    if foreground then utils.color.fill (self.label, foreground) end
end

return Key