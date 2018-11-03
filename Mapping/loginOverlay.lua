-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local text
local params
local parent

---------------------------------------------------------------------
-- BUTTONS
---------------------------------------------------------------------
local function handleConfirmButton( event )
 
    if ( "ended" == event.phase ) then
		print("CLICKED CONFIRM")
		print(params.type)
		if params.type == 'Login' or params.type == 'Logout' then
			print("CLOSING OVERLAY")
			parent:closeOverlay(true)
		elseif params.type == 'Failed' then
			parent:closeOverlay(false)
		end
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	local background = display.newRect( display.contentCenterX, display.contentCenterY, 0.5 * g_contentWidth, 0.5 * g_contentHeight )
	background:setFillColor('black'	)
	
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
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		
		parent = event.parent
		params = event.params
		
		print(params.type)
		
		if params.type == 'Login' then
			text.text = "You are logged in as\n" .. g_currentUser.name
		elseif params.type == 'Logout' then
			text.text = "You have successfully logged out."
		elseif params.type == 'Failed' then
			print("FAILED")
			text.text = "Wrong username/password"
		end
		
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end

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