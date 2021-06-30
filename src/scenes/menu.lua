-- components:
-- buttons
-- brief statistics view (only %)
-- footer
-- switchButton (for theme)

local composer = require( "composer" )

local widgets = require "src.widgets"
local theme = require "src.theme"
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
local keyboard

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
     
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- widgets.onSceneChanged (sceneGroup)
        keyboard = widgets.Keyboard ()
        keyboard:refill ({
            "qwertyuiop",
            "asdfghjkl",
            "zxcvbnm"
        })
        keyboard:subscribe (function (key, state)
            print (key, state)
            if state == "down" then
                local background = "negative"
                local foreground = "background"
                if key == "q" then
                    background = "positive"
                    foreground = "foreground"
                end
                keyboard:color (key, background, foreground)
            else
                keyboard:recolorKey (key)
            end
            return true
        end)

        local button = widgets.Button {
            image="assets/button.png",
            x=100, y=100,
            callback = function (event)
                -- keyboard:toggle ()
                -- print ("Button pressed")
                theme.next ()
            end}
        widgets.recolor ()

        Runtime:addEventListener ("tap", function (event)
            local circle = display.newCircle (sceneGroup, display.contentCenterX, display.contentCenterY, display.contentHeight)
            circle:setFillColor (unpack(theme.foreground))
            transition.from (circle.path, {radius = 1, time=2000, onComplete = function (object) display.remove (circle) end})
        end)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        keyboard:show ()
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    widgets.destroy ()
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene