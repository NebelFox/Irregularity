-- -------------------------------------
-- This is the template of a widget file
-- Please, follow the 
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
local M = {}
local metatable = {__index=M}
-- --= ==----------------== =--



-- --= ==-------------------------== =--
-- --= =-- common object methods --= =--
function M.show (self, ...)
    -- play show animation
end

function M.hide (self, ...)
    -- play hide animation
end

function M.recolor (self, ...)
    -- refill all the widget's components with colors of 'theme'
    -- Note that this method is used to initially color the instance
end

function M.destroy (self, ...)
    -- completely remove the object
    -- remove all the components of the instance here


    -- usually you don't need to touch this
    display.remove (self.group)
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

    -- @init


    -- @post-init
    self:recolor ()
    -- self:show ()
    return self
end
-- --= ==----------------------== =--



return new