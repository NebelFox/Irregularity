-- --------------------------------------
-- This is the template of a widget class
-- Don't forget to add this filename into
-- assets/widgets-config.json -----------
-- --------------------------------------

-- local alias of global variables
local display = display
local delay = timer.performWithDelay
local stage = display.getCurrentStage ()

-- required packages
local Publisher = require "src.publisher"

-- widget class
-- local TouchGuard = Publisher ()
local TouchGuard = Publisher({})

local function listener (event)
    return true
end

-- common widget methods overriding
-- avaliable methods: init, show, hide, showhide, recolor, destroy
function TouchGuard.init (self, args)
    self.rect = display.newRect (self.group, 0, 0,
        args.width or display.contentWidth,
        args.height or display.contentHeight)
    self.rect:setFillColor (1, 1, 1)
    self.group.anchorX, self.group.anchorY = args.anchorX or 0, args.anchorY or 0
    self.group.anchorChildren = true
    self.group.x, self.group.y = args.x or 0, args.y or 0
    self.rect.isVisible = false
    self.animationsRunning = 0

    self.rect:addEventListener ("touch", listener)
    self.rect:addEventListener ("tap", listener)

    self.subscribers = {}
end
function TouchGuard.destroy (self)
    -- completely remove the object
    -- remove all the components of the instance here
    self.rect:removeEventListener ("touch", listener)
    self.rect:removeEventListener ("tap", listener)
    display.remove (self.rect)
end

-- custom widget methods
local function timer (event)
    local self = event.source.invoker
    self.animationsRunning = self.animationsRunning - 1
    if self.animationsRunning == 0 then
        self.rect.isHitTestable = false
        -- stage:setFocus (nil)
        self:notify ("ended")
    end
end

function TouchGuard.isActive (self)
    return self.animationsRunning  ~= 0
end

function TouchGuard.activate (self, duration)
    if self.animationsRunning == 0 then
        self:notify ("began")
        -- stage:setFocus (self.rect)
        self.rect.isHitTestable = true
        self.group:toFront ()
    end
    self.animationsRunning = self.animationsRunning + 1
    delay (duration, timer).invoker = self
end

-- return Publisher(TouchGuard)
return TouchGuard