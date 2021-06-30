-- widget.lua
local function silence (self) end
local widgets = require "src.widgets"

local Widget = {
    init = function (self, args) end,
    show = silence,
    hide = silence,
    recolor = silence,
    destroy = silence
}
local metatable = {__index = Widget}

function Widget.isVisible (self)
    return self.group.isVisible
end

function Widget.showhide (self)
    if self:isVisible () then
        self:hide ()
    else
        self:show ()
    end
end

local function destroy (self, isSubWidget)
    display.remove (self.group)
    self.group = nil
    if self.parent == nil then widgets.forget (self) end
end

local function new (class, config)
    local Class = setmetatable ({}, {
        __index = setmetatable (class, {__index=Widget}),
        __call = function (_, args)
            local args = args or {}
            local self = setmetatable ({}, {__index=class})
            self.group = display.newGroup ()
            -- self.group.isVisible = args.isVisible or false
            if args.parent then
                self.parent = args.parent
                self.parent.group:insert (self.group)
            else
                widgets.register (self)
            end
            class.init (self, args)
            self:recolor ()
            return self
        end
    })
    -- Class.config = config
    class.config = setmetatable (config, {__index=function (t, k) return t[k] or 0 end})
    function Class.show (self)
        if self.parent == nil then widgets.guard:activate (config.showAnimationDuration) end
        class.show (self)
    end
    function Class.hide (self)
        if self.parent == nil then widgets.guard:activate (config.hideAnimationDuration) end
        class.hide (self)
    end
    function Class.destroy (self)
        class.destroy (self)
        destroy (self)
    end
    return Class
end

return new