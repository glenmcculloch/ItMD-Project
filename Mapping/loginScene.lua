-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local usernameField
local passwordField

local options = {
    isModal = true,
    effect = "fade",
    time = 400
}


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
local function checkLogin(username, password)
	-- username doesn't exist
	if g_admins[username] == nil then
		print("Username not found!")
		
	-- login is successful (it's a match!)
	elseif ( g_admins[username].password == password ) then
		g_currentUser = g_admins[username]
		success = true
		
	-- login was different
	else
		print("Password did not match!")
	end
end

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
		
		if usernameField.text ~= nil and passwordField ~= nil then
			checkLogin(usernameField.text, passwordField.text)
		end
    end
end

local function handleLoginButton( event )
 
    if ( "ended" == event.phase ) then
		if usernameField.text ~= nil and passwordField ~= nil then
			checkLogin(usernameField.text, passwordField.text)
		end
    end
end

local function handleCancelButton( event )
 
    if ( "ended" == event.phase ) then
		composer.removeScene(scene)
		
		composer.gotoScene("mapScene")
    end
end

local function handleLogoutButton( event )
 
    if ( "ended" == event.phase ) then
        g_currentUser = nil
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	-- logged in
	if g_currentUser ~= nil then
		local loginText = display.newText( string.format("Logged in as:\n%s", g_currentUser.name), display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
		
		local logoutButton = widget.newButton({
			x = display.contentCenterX - 50,
			y = display.contentCenterY + 110,
			id = "login",
			label = "Login",
			onEvent = handleLogoutButton
		})
		
		sceneGroup:insert(logoutButton)
		
		local cancelButton = widget.newButton({
			x = display.contentCenterX + 50,
			y = display.contentCenterY + 110,
			id = "cancel",
			label = "Cancel",
			onEvent = handleCancelButton
		})
		
		sceneGroup:insert(loginText)
		sceneGroup:insert(logoutButton)
		sceneGroup:insert(cancelButton)
		
	-- need to login
	else
		local loginText = display.newText( "Administrator Login", display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
		
		sceneGroup:insert(loginText)
		
		local loginButton = widget.newButton({
			x = display.contentCenterX - 50,
			y = display.contentCenterY + 110,
			id = "login",
			label = "Login",
			onEvent = handleLoginButton
		})
		
		sceneGroup:insert(loginButton)
		
		local cancelButton = widget.newButton({
			x = display.contentCenterX + 50,
			y = display.contentCenterY + 110,
			id = "cancel",
			label = "Cancel",
			onEvent = handleCancelButton
		})
		
		sceneGroup:insert(cancelButton)
	end
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		
		usernameField = native.newTextField( display.contentCenterX, display.contentCenterY + 30, 220, 36 )
		usernameField.font = native.newFont( native.systemFontBold, 24 )
		usernameField.placeholder = "Username"
		usernameField:setTextColor( 0.4, 0.4, 0.8 )
		usernameField:addEventListener( "userInput", onUsername )
		
		passwordField = native.newTextField( display.contentCenterX, display.contentCenterY + 70, 220, 36 )
		passwordField.font = native.newFont( native.systemFontBold, 24 )
		passwordField.placeholder = "Password"
		passwordField.isSecure = true
		passwordField:setTextColor( 0.4, 0.4, 0.8 )
		passwordField:addEventListener( "userInput", onPassword )
		
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		usernameField:removeSelf()
		usernameField = nil
		
        passwordField:removeSelf()
        passwordField = nil
		
		
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