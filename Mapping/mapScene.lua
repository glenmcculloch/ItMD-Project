-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()


-- Function to listen to the webview and register any clicks on the map
function webViewListener(event)

	-- a country was clicked
	if event.url and event.type == "other" then
		local data = string.gsub(event.url, "%%20", " ")
		data = split(data, ":")
		
		print(data[2])
		
		if g_currentRegion == 'World' then
			g_currentRegion = data[2]
			loadMap(g_currentRegion)
		end
	end
end

function shiftMap()
	if g_mapView_hidden == false then
		g_mapView_hidden = true
		transition.moveTo(g_mapView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=g_transitionTime })
	else
		g_mapView_hidden = false
		transition.moveTo(g_mapView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=g_transitionTime })
	end
end

function loadMap(region)
	g_mapView:removeSelf()
	
	g_currentRegion = region
	
	g_mapView = native.newWebView( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
	g_mapView:request( string.format("%s-map.html", region), system.DocumentsDirectory )
	
	g_mapView:addEventListener( "urlRequest", webViewListener )
end


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
local searchField
local function onSearch( event )
	
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
	
    elseif ( event.phase == "submitted" ) then
	
        if event.target.text ~= nil then
			local result = searchForCountry(event.target.text, g_currentRegion)
			
			if result ~= nil then
				g_currentRegion = result[1]
				g_currentSelection = result[2]
				
				g_selectionData = g_countries[result[1]][result[2]]
				
				loadMap(g_currentRegion)
			else
				print("Country was not found...")
			end
		end
    end
end

searchField = native.newTextField( display.contentCenterX, g_iconSeparation[2], g_contentWidth - 30 - 4 * ( g_iconSeparation[1] + g_iconSize ), 50 )
searchField.isVisible = false

searchField:addEventListener( "userInput", onSearch )

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


---------------------------------------------------------------------
-- LOGIN BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleLoginButton( event )
	
    if ( "ended" == event.phase ) then
        print("Login Button was pressed!")
    end
end

-- Create the widget
local loginButton = widget.newButton(
    {
        width = g_iconSize,
        height = g_iconSize,
        defaultFile = "user-icon.png",
        overFile = "user-icon.png",
        onEvent = handleLoginButton
    }
)
-- Center the button
loginButton.x = 0
loginButton.y = g_iconSeparation[2]

g_displayMenu:insert(loginButton)


---------------------------------------------------------------------
-- EDIT BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleEditButton( event )
	
    if ( "ended" == event.phase ) then
        print("Edit Button was pressed!")
		
		
		shiftMap()
	end
end

-- Create the widget
local editButton = widget.newButton(
    {
        width = g_iconSize,
        height = g_iconSize,
        defaultFile = "edit-icon.png",
        overFile = "edit-icon.png",
        onEvent = handleEditButton
    }
)

-- Center the button
editButton.x = g_contentWidth - 30 - 2 * ( g_iconSize + g_iconSeparation[1] )
editButton.y = g_iconSeparation[2]

g_displayMenu:insert(editButton)


---------------------------------------------------------------------
-- BACK BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleBackButton( event )
	
    if ( "ended" == event.phase ) then
        print("Back button was pressed!")
		
		if g_currentRegion ~= 'World' then
			loadMap('World')
		end
	end
end

-- Create the widget
local backButton = widget.newButton(
    {
        width = g_iconSize,
        height = g_iconSize,
        defaultFile = "back-icon.png",
        overFile = "back-icon.png",
        onEvent = handleBackButton
    }
)

-- Center the button
backButton.x = g_contentWidth - 30 - g_iconSize - g_iconSeparation[1]
backButton.y = g_iconSeparation[2]

g_displayMenu:insert(backButton)


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local screenGroup = self.view
	loadMap(g_currentRegion)
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