-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local mapView

local infoContainer = display.newGroup()
local info_Region = 'World'

-- Function to listen to the webview and register any clicks on the map
function webViewListener(event)

	-- a country was clicked
	if event.url and event.type == "other" then
		local data = string.gsub(event.url, "%%20", " ")
		data = split(data, ":")
		
		local regionSelected = data[2]
		
		-- load map only if we are on the world main view
		if g_currentRegion == 'World' then
			loadMap(regionSelected)
		end
		
		g_currentRegion = regionSelected
		loadInformation(g_currentRegion)
	end
end

function shiftMap()
	if g_mapView_hidden == false then
		g_mapView_hidden = true
		transition.moveTo(mapView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=g_transitionTime })
	else
		g_mapView_hidden = false
		transition.moveTo(mapView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=g_transitionTime })
	end
end

function loadMap(region)
	-- remove mapview if it exists already (needed to reload the map)
	if mapView then
		mapView:removeSelf()
	end
	
	g_currentRegion = region
	
	-- request the correct map
	mapView = native.newWebView( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
	mapView:request( string.format("%s-map.html", region), system.DocumentsDirectory )
	
	mapView:addEventListener( "urlRequest", webViewListener )
end

function loadInformation(region)
	-- remove mapview if it exists already (needed to reload the map)
	if region == 'World' then
		info_Region.text = "Legal Climates around the World"
	else
		info_Region.text = string.format("%s - Rating: %d", g_currentRegion, math.random(10))
	end
end

function shiftMap()
	if g_mapView_hidden == false then
		g_mapView_hidden = true
		transition.moveTo(mapView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=g_transitionTime })
	else
		g_mapView_hidden = false
		transition.moveTo(mapView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=g_transitionTime })
	end
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
local function handleInfoButton( event )
	
    if ( "ended" == event.phase ) then
        print("Info Button was pressed!")
		
		
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
			loadInformation('World')
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	sceneGroup:insert(infoContainer)
	
	local infoBackground = display.newRect(g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2])
	infoBackground:setFillColor(0.5)
	
	sceneGroup:insert(infoBackground)
	
	info_Region = display.newText('Legal Climates around the World', display.contentCenterX, g_iconSeparation[2], native.systemFont, 16)
	info_Region:setFillColor(1,1,1)
	
	infoContainer:insert(info_Region)
	
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
	local infoButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "edit-icon.png",
			overFile = "edit-icon.png",
			onEvent = handleInfoButton
		}
	)

	-- place the button
	infoButton.x = g_contentWidth - 30 - 2 * ( g_iconSize + g_iconSeparation[1] )
	infoButton.y = g_iconSeparation[2]
	
	sceneGroup:insert(infoButton)
	
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