--  africa Map Scene

local composer = require( "composer" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local screenGroup = self.view
	
    -- Code here runs when the scene is first created but has not yet appeared on screen
	local container = display.newGroup()

	local top = 0
	local left = 0
	local bottom = content_height
	local right = content_width

	local content = display.newRect( left, top, right, bottom )
	content:setFillColor(0.4, 0.4, 0.4)
	content.anchorX = 0
	content.anchorY = 0

	container:insert(content)

	local webView = native.newWebView( display.contentCenterX, display.contentCenterY, content_width, content_height )
    webView:request( "Africa-map.html", system.DocumentsDirectory )
	
	container:insert(webView)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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