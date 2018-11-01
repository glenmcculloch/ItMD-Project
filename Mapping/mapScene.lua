-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local mapView

-- Setup our map details
mapView_size = {g_contentWidth, g_contentHeight - (g_contentHeight / 8)}
mapView_defaultCoordinates = {display.contentCenterX, display.contentCenterY + (g_contentHeight / 8)}
mapView_hideCoordinates = {mapView_size[1] * 2, display.contentCenterY + (g_contentHeight / 8)}
mapView_hidden = false

-- Setup our edit details area
editView_defaultCoordinates = {display.contentCenterX, display.contentCenterY}
editView_size = {mapView_size[1] - 100, g_contentHeight}


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
	if mapView_hidden == false then
		mapView_hidden = true
		transition.moveTo(mapView, { x=mapView_hideCoordinates[1], y=mapView_hideCoordinates[2], time=g_transitionTime })
	else
		mapView_hidden = false
		transition.moveTo(mapView, { x=mapView_defaultCoordinates[1], y=mapView_defaultCoordinates[2], time=g_transitionTime })
	end
end

function loadMap(region)
	if mapView then 
		mapView:removeSelf()
	end
	
	g_currentRegion = region
	
	mapView = native.newWebView( mapView_defaultCoordinates[1], mapView_defaultCoordinates[2], mapView_size[1], mapView_size[2] )
	mapView:request( string.format("%s-map.html", region), system.DocumentsDirectory )
	
	mapView:addEventListener( "urlRequest", webViewListener )
end


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
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

-- Function to handle button events
local function handleSearchButton( event )
	
    if ( "ended" == event.phase ) then
		
		local searchField = native.newTextField( display.contentCenterX, g_iconSeparation[2], g_contentWidth - 30 - 4 * ( g_iconSeparation[1] + g_iconSize ), 50 )
		searchField:addEventListener( "userInput", onSearch )
    end
end


---------------------------------------------------------------------
-- LOGIN BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleLoginButton( event )
	
    if ( "ended" == event.phase ) then
        print("Login Button was pressed!")
		
		composer.removeScene("mainScene")
		composer.gotoScene("loginScene")
    end
end


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


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	-- Back button
	local backButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "back-icon.png",
			overFile = "back-icon.png",
			onEvent = handleBackButton
		}
	)

	-- place the button
	backButton.x = g_contentWidth - 30 - g_iconSize - g_iconSeparation[1]
	backButton.y = g_iconSeparation[2]
	
	sceneGroup:insert(backButton)
	
	-- Edit button
	local editButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "edit-icon.png",
			overFile = "edit-icon.png",
			onEvent = handleEditButton
		}
	)

	-- place the button
	editButton.x = g_contentWidth - 30 - 2 * ( g_iconSize + g_iconSeparation[1] )
	editButton.y = g_iconSeparation[2]
	
	sceneGroup:insert(editButton)
	
	-- Login button
	local loginButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "user-icon.png",
			overFile = "user-icon.png",
			onEvent = handleLoginButton
		}
	)
	
	-- place the button
	loginButton.x = 0
	loginButton.y = g_iconSeparation[2]
	
	sceneGroup:insert(loginButton)
	
	-- search button
	local searchButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "search-icon.png",
			overFile = "search-icon.png",
			onEvent = handleSearchButton
		}
	)
	
	-- place the button
	searchButton.x = 0 + g_iconSize + g_iconSeparation[1]
	searchButton.y = g_iconSeparation[2]
	
	sceneGroup:insert(searchButton)
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		loadMap(g_currentRegion)
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		if mapView and mapView.removeSelf then
            mapView:removeSelf()
            mapView = nil
        end
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