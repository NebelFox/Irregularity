-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require "composer"

-- local widgets = require "src.widgets"
require ("src.widgets").init {
    "template",
    "button"
}

math.randomseed (os.time ())

-- composer.gotoScene ("src.scenes.menu")