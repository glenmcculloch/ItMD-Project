-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local parent
local text


---------------------------------------------------------------------
-- BUTTONS
---------------------------------------------------------------------
local function handleConfirmButton( event )
 
    if ( "ended" == event.phase ) then
		parent:closeOverlay(false)
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	local background = display.newRect( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
	background:setFillColor('black')
	
	sceneGroup:insert(background)
	
	-- Edit button
	local confirmButton = widget.newButton(
		{
			label = "Okay",
			x = display.contentCenterX,
			y = display.contentCenterY + 30,
			width = 100,
			height = 30,
			cornerRadius = 5,
			fillColor = { default={1,1,1,0.5}, over={1,1,1,0.5} },
			strokeColor = { default={1,1,1,0.9}, over={1,1,1,0.9} },
			strokeWidth = 4, 
			onEvent = handleConfirmButton
		}
	)
	
	sceneGroup:insert(confirmButton)
	
	text = display.newText(
		{
			text = "", 
			align = "center",
			x = display.contentCenterX, 
			y = display.contentCenterY - 20, 
			font = native.systemFont,
			fontSize = 16
		}
	)
	
	text:setFillColor(1,1,1,1)
	
	sceneGroup:insert(text)
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
	
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is still off screen (but is about to come on screen) --]]
		parent = event.parent
		text.text = "Unable to find country."
		
    elseif ( phase == "did" ) then
        --[[ Code here runs when the scene is entirely on screen --]]
		
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is on screen (but is about to go off screen) --]]
		
    elseif ( phase == "did" ) then
        --[[ Code here runs immediately after the scene goes entirely off screen --]]
 
    end
end

function scene:destroy( event )
 
    local sceneGroup = self.view
    --[[ Code here runs prior to the removal of scene's view --]]
 
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