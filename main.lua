-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require "composer"

local widgets = require "src.widgets"
require ("src.theme").init ()
local theme = require "src.theme"
theme.init ()

local widgets = require ("src.widgets")
widgets.init ()

local button = widgets.Button {x=100, y=100,
    image="assets\\button.png",
    callback = function ()
        print ("button.callback")
        theme.next ()
        widgets.guard:activate (1000)
    end}
button:show ()

math.randomseed (os.time ())

-- composer.gotoScene ("src.scenes.menu")