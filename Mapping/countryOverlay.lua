local composer = require( "composer" )
 
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local sceneGroup = self.view
	local params = event.params
    
	local container = display.newRect( display.contentCenterX, display.contentCenterY, content_width - 50, content_height - 50 )
	container.fill = { 1, 1, 1 }
	
	sceneGroup:insert(container)
	
	--print(params.country_data)
	
	local iter = 0
	
	-- iterate through characteristics
	for key,value in pairs(params.country_data) do
		
		local toString = string.format("%s - %s", key, value)
		local text = display.newText(sceneGroup, toString, 100, 100 + iter, native.systemFont, 16 )
		text:setFillColor( 1, 0, 0 )
		sceneGroup:insert(text)
		
		iter = iter + 20
	end
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