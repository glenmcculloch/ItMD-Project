-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local loginText
local loginButton
local cancelButton
local usernameField
local passwordField

-- login overlay
local options = {
    effect = "fade",
    time = 500,
    isModal = true
}


---------------------------------------------------------------------
-- SPECIFIC FUNCTIONS
---------------------------------------------------------------------
local function openOverlay(type)
	if usernameField then
		usernameField.isVisible = false
		passwordField.isVisible = false
	end
	
	options.params = {type=type}
	composer.showOverlay("loginOverlay", options)
end

function scene:closeOverlay(exit)
	
	if exit then
		composer.hideOverlay()
		composer.removeScene(scene)
		
		composer.gotoScene("mapScene")
	else
		composer.hideOverlay( "fade", 400 )
		
		usernameField.isVisible = true
		passwordField.isVisible = true
	end
end


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
local function checkLogin(username, password)
	-- username doesn't exist
	if g_admins[username] ~= nil then
		if g_admins[username].password == password then
			g_currentUser = g_admins[username]
			
			openOverlay('Login')
		else
			openOverlay('Failed')
		end
	-- login is unsuccessful (it's a match!)
	else
		openOverlay('Failed')
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
	
		-- logout
		if g_currentUser ~= nil then
			g_currentUser = nil
			
			openOverlay('Logout')
		-- login
		else
			if usernameField.text ~= nil and passwordField ~= nil then
				checkLogin(usernameField.text, passwordField.text)
			end
		end
    end
end

local function handleCancelButton( event )
 
    if ( "ended" == event.phase ) then
		composer.removeScene(scene)
		composer.gotoScene("mapScene")
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )
	print("SCENE IS BEING CREATED")

    local sceneGroup = self.view
	
	loginText = display.newText({
		text = "Administrator Login", 
		x = display.contentCenterX, 
		y = display.contentCenterY, 
		font = native.systemFontBold, 
		fontSize = 16, 
		align = "center"
	})
	
	sceneGroup:insert(loginText)
	
	loginButton = widget.newButton({
		x = display.contentCenterX - 60,
		y = display.contentCenterY + 75,
		width = 90,
		height = 25,
		id = "login",
		label = "Login",
		cornerRadius = 5,
		shape = "roundedRect", 
		fillColor = { default={1,1,1,0.5}, over={1,1,1,0.5} },
		strokeColor = { default={1,1,1,0.9}, over={1,1,1,0.9} },
		strokeWidth = 3, 
		onEvent = handleLoginButton
	})
	
	sceneGroup:insert(loginButton)
	
	cancelButton = widget.newButton({
		x = display.contentCenterX + 60,
		y = display.contentCenterY + 75,
		width = 90,
		height = 25,
		id = "cancel",
		label = "Cancel",
		cornerRadius = 5,
		shape = "roundedRect", 
		fillColor = { default={1,1,1,0.5}, over={1,1,1,0.5} },
		strokeColor = { default={1,1,1,0.9}, over={1,1,1,0.9} },
		strokeWidth = 3, 
		onEvent = handleCancelButton
	})
	
	sceneGroup:insert(cancelButton)
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is still off screen (but is about to come on screen) --]]
		
		-- logout
		if g_currentUser ~= nil then
			loginText.text = "Logged in as:\n\n" .. g_currentUser.name
			loginText.y = display.contentCenterY
			loginButton:setLabel("Logout")
		-- login
		else
			loginText.text = "Administrator Login"
			loginText.y = display.contentCenterY - 60
			loginButton:setLabel("Login")
		end
    elseif ( phase == "did" ) then
        --[[ Code here runs when the scene is entirely on screen --]]
		
		-- only create fields if we're logging in
		if g_currentUser == nil then
			usernameField = native.newTextField( display.contentCenterX, display.contentCenterY - 25, g_contentWidth * 0.4, 40 )
			usernameField.font = native.newFont( native.systemFontBold, 16 )
			usernameField.placeholder = "Username"
			usernameField:setTextColor( 0.4, 0.4, 0.8 )
			usernameField:addEventListener( "userInput", onUsername )
			
			passwordField = native.newTextField( display.contentCenterX, display.contentCenterY + 25, g_contentWidth * 0.4, 40  )
			passwordField.font = native.newFont( native.systemFontBold, 16 )
			passwordField.placeholder = "Password"
			passwordField.isSecure = true
			passwordField:setTextColor( 0.4, 0.4, 0.8 )
			passwordField:addEventListener( "userInput", onPassword )
		end
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is on screen (but is about to go off screen) --]]
		
		if usernameField then
			usernameField:removeSelf()
			usernameField = nil
			
			passwordField:removeSelf()
			passwordField = nil
		end
    elseif ( phase == "did" ) then
        --[[ Code here runs immediately after the scene goes entirely off screen --]]
 
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