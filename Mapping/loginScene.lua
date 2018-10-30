-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()


local loginButton
local loginText
local usernameField
local passwordField


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
		
		print("Login successful!")
		
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

local function handleLogoutButton( event )
 
    if ( "ended" == event.phase ) then
        g_currentUser = nil
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local screenGroup = self.view
	
	-- logged in
	if g_currentUser ~= nil then
		loginText = display.newText( string.format("Logged in as:\n%s", g_currentUser.name), display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
		
		loginButton = widget.newButton({
			x = display.contentCenterX,
			y = display.contentCenterY + 110,
			id = "logout",
			label = "Logout",
			onEvent = handleLoginButton
		})
		
		screenGroup:insert(loginText)
		screenGroup:insert(loginButton)
		
	-- need to login
	else
		loginText = display.newText( "Administrator Login", display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
		
		screenGroup:insert(loginText)
		
		usernameField = native.newTextField( display.contentCenterX, display.contentCenterY + 30, 220, 36 )
		usernameField.font = native.newFont( native.systemFontBold, 24 )
		usernameField.placeholder = "Username"
		usernameField:setTextColor( 0.4, 0.4, 0.8 )
		usernameField:addEventListener( "userInput", onUsername )
		
		screenGroup:insert(usernameField)
		
		passwordField = native.newTextField( display.contentCenterX, display.contentCenterY + 70, 220, 36 )
		passwordField.font = native.newFont( native.systemFontBold, 24 )
		passwordField.placeholder = "Password"
		passwordField.isSecure = true
		passwordField:setTextColor( 0.4, 0.4, 0.8 )
		passwordField:addEventListener( "userInput", onPassword )
		
		screenGroup:insert(passwordField)
		
		loginButton = widget.newButton({
			x = display.contentCenterX,
			y = display.contentCenterY + 110,
			id = "login",
			label = "Login",
			onEvent = handleLoginButton
		})
		
		screenGroup:insert(loginButton)
		
	end
	
	shiftMap()
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