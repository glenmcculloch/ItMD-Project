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
local info_Region
local info_Additional
local info_Details = {}
local info_Value = {}

-- needs to be used globally in this file (to set visible or not)
local editButton

-- search overlay
local options = {
    effect = "fade",
    time = 500,
    isModal = true
}

local separation = 40


---------------------------------------------------------------------
-- SPECIFIC FUNCTIONS
---------------------------------------------------------------------
local function openOverlay()
	mapView.isVisible = false
	composer.showOverlay("searchOverlay", options)
end

function scene:closeOverlay()
	mapView.isVisible = true
	composer.hideOverlay( "fade", 400 )
end

-- loads information into the background when a region/country is clicked
function loadInformation(region, country)
	
	-- world information (load details)
	if region == 'World' then
		info_Region.text = "Legal Climates around the World"
		info_Additional.text = "Please click on a country to display its details."
		
		-- iterate through each characteristic and create info buttons and info labels
		for i = 1, MAX_CHARACTERISTICS, 1 do
			data = g_countryCharacteristics[i]
			
			if data.id ~= 'Rating' then
				info_Value[data.id]:setLabel("")
			end
		end
		
	-- country is selected, load the details!
	elseif country ~= nil then
		info_Region.text = string.format("%s (Rating: %d)", country, g_countries[country]['rating'])
		
		local data
		local line = ""
		
		-- start looping through all characteristics for this country
		for i = 1, MAX_CHARACTERISTICS, 1 do
			data = g_countryCharacteristics[i]
			
			if data.id ~= 'Rating' then
				line = line .. '\n' .. data.id .. "(" .. g_countrySetting[g_countries[country]['data'][data.id]] .. ")"
			end
		end
		
		-- iterate through each characteristic and create info buttons and info labels
		for i = 1, MAX_CHARACTERISTICS, 1 do
			data = g_countryCharacteristics[i]
			
			if data.id ~= 'Rating' then
				info_Value[data.id]:setLabel(g_countrySetting[g_countries[g_currentCountry]['data'][data.id]])
			end
		end
		
		info_Additional.text = g_countries[country]['info']
	else
		info_Region.text = string.format("%s", region)
	end
end

-- Function to listen to the webview and register any clicks on the map
local function webViewListener(event)
	-- a region was clicked
	if event.url and event.type == "other" then
		local line = string.gsub(event.url, "%%20", " ")
		local data = split(line, ":")
		local selected = data[2]
		
		-- check if it was a region that was selected, or a country
		if g_regionId[selected] ~= nil then
			g_currentRegion = selected
			loadInformation(g_currentRegion, g_currentCountry)
			
			g_mapView_hidden = false
			
			-- remove mapview if it exists already (needed to reload the map)
			if mapView and mapView.removeSelf then
				mapView:removeSelf()
				mapView = nil
			end
			
			-- request the correct map
			mapView = native.newWebView( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
			mapView:request( string.format("%s-map.html", g_currentRegion), system.DocumentsDirectory )
			
			mapView:addEventListener( "urlRequest", webViewListener )
		-- if it was not a region, set country selected
		else
			local country = g_codeToCountry[selected]
			
			if g_countries[country] ~= nil then
				g_currentCountry = country
				loadInformation(g_currentRegion, g_currentCountry)
				
				g_mapView_hidden = false
				
				-- remove mapview if it exists already (needed to reload the map)
				if mapView and mapView.removeSelf then
					mapView:removeSelf()
					mapView = nil
				end
				
				-- request the correct map
				mapView = native.newWebView( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
				mapView:request( string.format("%s-map.html", g_currentCountry), system.DocumentsDirectory )
				
				mapView:addEventListener( "urlRequest", webViewListener )
			end
		end
	end
end

function loadMap()
	local region
	loadInformation(g_currentRegion, g_currentCountry)
	
	if g_currentCountry ~= nil then
		region = g_currentCountry
	else
		region = g_currentRegion
	end
	
	g_mapView_hidden = false

	-- remove mapview if it exists already (needed to reload the map)
	if mapView and mapView.removeSelf then
		mapView:removeSelf()
		mapView = nil
	end
	
	-- request the correct map
	mapView = native.newWebView( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
	mapView:request( string.format("%s-map.html", region), system.DocumentsDirectory )
	
	mapView:addEventListener( "urlRequest", webViewListener )
end

function shiftMap()

	-- display map
	if g_mapView_hidden == false then
		g_mapView_hidden = true
		transition.moveTo(mapView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=g_transitionTime })
		
		-- show edit button (if user is logged in)
		if g_currentCountry ~= nil and g_currentUser ~= nil then
			editButton.isVisible = true
		end
		
	-- hide map
	else
		g_mapView_hidden = false
		transition.moveTo(mapView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=g_transitionTime })
		
		-- hide button if necessary
		if editButton.isVisible then
			editButton.isVisible = false
		end
	end
end


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
local searchField
local function onSearch( event )
	
    if ( event.phase == "began" ) then
        searchField.text = event.target.text
	
    elseif ( event.phase == "submitted" ) then
	
        if event.target.text ~= nil then
			local result = searchForCountry(event.target.text)
			
			-- found the country!
			if result ~= nil then
				
				-- same again, load information only if it isn't the same country
				if g_currentCountry ~= result[1] then
					g_currentRegion = result[1]
					g_currentCountry = result[2]
					
					loadMap()
				end
			else
				openOverlay()
			end
		end
		
		searchField:removeSelf()
		searchField = nil
		
		native.setKeyboardFocus(nil)
    end
end

-- Function to handle button events
local function handleSearchButton( event )
	
    if ( "ended" == event.phase ) then
		
		if searchField then
			searchField:removeSelf()
			searchField = nil
			
			native.setKeyboardFocus(nil)
		else
			searchField = native.newTextField( display.contentCenterX, g_iconSeparation[2], g_contentWidth * 0.5, g_iconSize )
			searchField.placeholder = "Search for country..."
			searchField:addEventListener( "userInput", onSearch )
			
			native.setKeyboardFocus(searchField)
		end
    end
end


---------------------------------------------------------------------
-- LOGIN BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleLoginButton( event )
	
    if ( "ended" == event.phase ) then
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
		shiftMap()
	end
end


---------------------------------------------------------------------
-- EDIT BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleEditButton( event )
	
    if ( "ended" == event.phase ) then
		-- just to make sure that admin is logged in
		if g_currentUser ~= nil then
			composer.gotoScene("editScene")
		end
	end
end


---------------------------------------------------------------------
-- BACK BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleBackButton( event )
	
    if ( "ended" == event.phase ) then
		-- return to region from country
		if g_currentCountry ~= nil then
			g_currentCountry = nil
			
			loadMap()
		-- return to world from region
		elseif g_currentRegion ~= 'World' then
			g_currentRegion = 'World'
			loadMap()
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	
	sceneGroup:insert(infoContainer)
	
	info_Region = display.newText('Legal Climates around the World', display.contentCenterX, g_iconSeparation[2], native.systemFontBold, 16)
	info_Region:setFillColor(1,1,1)
	
	infoContainer:insert(info_Region)
	
	local y_pos = g_contentHeight / 5 + 10
	local data
	
	-- info scroller
	local scroll_width = ( g_mapView_size[1] / 2 ) - 25
	local scroll_height = g_mapView_size[2] - 80
	
	infoScroller = widget.newScrollView(
		{
			left = display.contentCenterX, 
			top = y_pos, 
			width = scroll_width, 
			height = scroll_height, 
			backgroundColor = { 0.5 }
		}
	)
	
	infoContainer:insert(infoScroller)
	
	y_pos = y_pos + ( 0.5 * separation )
	
	-- iterate through each characteristic and create buttons and info labels
	for i = 1, MAX_CHARACTERISTICS, 1 do
		data = g_countryCharacteristics[i]
		
		if data.id ~= 'Rating' then
			info_Details[data.id] = display.newText(
				{
					text = data.id,
					x = 0, 
					y = y_pos, 
					font = native.systemFont, 
					fontSize = 16,
					align = "left"
				}
			)
			
			info_Details[data.id].anchorX = 0
			sceneGroup:insert(info_Details[data.id])
			
			info_Value[data.id] = widget.newButton(
				{
					x = display.contentCenterX - ( 0.1 * g_contentWidth ), 
					y = y_pos, 
					width = 75, 
					height = 30, 
					id = data.id, 
					shape = "roundedRect", 
					fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } }, 
					strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } }, 
					label = "", 
					font = native.systemFont, 
					fontSize = 16
				}
			)
			
			sceneGroup:insert(info_Value[data.id])
			
			y_pos = y_pos + separation
		end
	end
	
	-- additional information
	info_Additional = display.newText(
		{
			text = "...", 
			x = scroll_width / 2, 
			y = scroll_height / 2, 
			width = scroll_width, 
			height = scroll_height, 
			font = native.systemFont, 
			fontSize = 16, 
			align = "left"
		}
	)
	
	info_Additional:setFillColor(1, 1, 1)
	infoScroller:insert(info_Additional)
	
	-- Back button
	local backButton = widget.newButton(
		{
			x = g_contentWidth - g_iconSize * 2,
			y = g_iconSeparation[2],
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "back-icon.png",
			overFile = "back-icon.png",
			onEvent = handleBackButton
		}
	)
	
	-- place the button
	backButton.x = g_contentWidth - g_iconSize * 2
	backButton.y = g_iconSeparation[2]
	
	sceneGroup:insert(backButton)
	
	-- Edit button
	local infoButton = widget.newButton(
		{
			x = backButton.x - g_iconSeparation[1] - g_iconSize,
			y = g_iconSeparation[2],
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "info-icon.png",
			overFile = "info-icon.png",
			onEvent = handleInfoButton
		}
	)
	
	sceneGroup:insert(infoButton)
	
	-- Login button
	local loginButton = widget.newButton(
		{
			x = 0,
			y = g_iconSeparation[2],
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "user-icon.png",
			overFile = "user-icon.png",
			onEvent = handleLoginButton
		}
	)
	
	sceneGroup:insert(loginButton)
	
	-- search button
	local searchButton = widget.newButton(
		{
			x = loginButton.x + g_iconSize + g_iconSeparation[1],
			y = g_iconSeparation[2],
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "search-icon.png",
			overFile = "search-icon.png",
			onEvent = handleSearchButton
		}
	)
	
	sceneGroup:insert(searchButton)
	
	-- Edit button
	editButton = widget.newButton(
		{
			x = g_contentWidth - g_iconSize - g_iconSeparation[2],
			y = g_contentHeight - g_iconSeparation[2],
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "edit-icon.png",
			overFile = "edit-icon.png",
			onEvent = handleEditButton
		}
	)

	editButton.isVisible = false
	
	sceneGroup:insert(editButton)--]]
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		loadMap()
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
		
		if searchField and searchField.removeSelf then
			searchField:removeSelf()
			searchField = nil
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