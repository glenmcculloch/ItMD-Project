-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
local loginField
local function onUsername( event )
	if ( "began" == event.phase ) then
		-- This is the "keyboard appearing" event.
		-- In some cases you may want to adjust the interface while the keyboard is open.

	elseif ( "submitted" == event.phase ) then
		-- Automatically tab to password field if user clicks "Return" on virtual keyboard.
		native.setKeyboardFocus( passwordField )
	end
end
  
local function onPassword( event )
    -- Hide keyboard when the user clicks "Return" in this field
    if ( "submitted" == event.phase ) then
        native.setKeyboardFocus( nil )
    end
end

usernameField = native.newTextField( 50, 150, 220, 36 )
usernameField.font = native.newFont( native.systemFontBold, 24 )
usernameField.text = ""
usernameField:setTextColor( 0.4, 0.4, 0.8 )
usernameField:addEventListener( "userInput", onUsername )


-- Function to handle button events
local function handleSearchButton( event )
	
    if ( "ended" == event.phase ) then
		searchField.isVisible = true
    end
end

-- Create the widget
local searchButton = widget.newButton(
    {
        width = g_iconSize,
        height = g_iconSize,
        defaultFile = "search-icon.png",
        overFile = "search-icon.png",
        onEvent = handleSearchButton
    }
)
-- Center the button
searchButton.x = 0 + g_iconSize + g_iconSeparation[1]
searchButton.y = g_iconSeparation[2]

g_displayMenu:insert(searchButton)



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local screenGroup = self.view
	
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
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