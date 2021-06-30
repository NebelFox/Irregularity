local Keyboard = {}

local dislplay = display
local floor = math.floor
local transition = math.transition

local theme = require "src.theme"
local widgets = require "src.widgets"
local Key = require "src.widgets.key"

function Keyboard.init (self, args)
    self.group.anchorChildren = true
    self.group.x = display.contentCenterX
    self.group.anchorY = 1
    self.y = display.contentHeight - self.margin
    self.group.y = display.contentHeight - self.margin

    self.subscribers = {}

    self.keys = {}
end

function Keyboard.show (self)
    transition.to (self.group, {
        y=-self.group.contentHeight,
        time=self.config.showAnimationDuration,
        delta=true
    })
end

function Keyboard.hide (self)
    transition.to (self.group, {
        y=self.group.contentHeight,
        time=self.config.hideAnimationDuration,
        delta=true,
        onComplete=function (object)
            object.isVisible = false
        end
    })
end

function Keyboard.recolor (self)
    for id, key in pairs (self.keys) do
        key:recolor ()
    end
end

function Keyboard.destroy (self)
    self:refill ({})
    for i=1, #self.subscribers do
        self.subscribers[i] = nil
    end
end

function Keyboard.subscribe (self, subscriber)
    table.insert (self.subscribers, subscriber)
end
function Keyboard.unsubscribe (self, subscriber)
    table.remove (self.subscribers, table.indexOf (subscriber))
end
function Keyboard.press (self, key, state)
    -- self.group:dispatchEvent ({name="key", key=key})
    local use = false
    for _, subscriber in ipairs (self.subscribers) do
        use = use or subscriber (key, state)
    end
    if use then
        self.keys[key]:use ()
    end
end

function Keyboard.refill (self, keyscheme)
    for id, key in pairs (self.keys) do
        key:destroy ()
        self.keys[id] = nil
    end

    local keyWidth = self.keyWidth
    local keyHeight = self.keyHeight
    local margin = self.margin
    for rowIndex, row in ipairs (keyscheme) do
        local padding = (floor((display.contentWidth - margin*2) / #row) - keyWidth)
        local keyPlusPadding = keyWidth + padding
        for index=1, #row do
            local key = string.sub (row, index, index)
            local x = margin + (keyPlusPadding/2) + (index-1)*keyPlusPadding
            local y = margin + (rowIndex)*(keyHeight+margin)
            self.keys[key] = Key (self.group, {key=key, lifespan=0, x=x, y=y, parent=self})
        end
    end
    if not self:isVisible () then
        self.group.y = self.group.y + self.group.contentHeight
    end
    -- self.hiddenY = self.visibleY + self.group.contentHeight
end

function Keyboard.colorKey (self, key, background, foreground)
    self.keys[key]:color (background, foreground)
end

function Keyboard.recolorKey (self, key)
    self.keys[key]:recolor ()
end

return Keyboard