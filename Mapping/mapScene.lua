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
local info_Details

-- needs to be used globally in this file (to set visible or not)
local editButton

-- Function to listen to the webview and register any clicks on the map
function webViewListener(event)

	-- a region was clicked
	if event.url and event.type == "other" then
		local data = string.gsub(event.url, "%%20", " ")
		data = split(data, ":")
		
		local selectedRegion = data[2]
		
		-- check if it was a region that was selected, or a country
		local isRegion = false
		for key,value in pairs(g_countries) do
			if key == selectedRegion then
				isRegion = true
			end
		end
		
		-- load regional map if it was a region
		if isRegion then
			loadMap(selectedRegion)
			g_currentRegion = selectedRegion
		-- if it was not a region, set country selected
		else
			g_currentCountry = selectedRegion
		end
		
		loadInformation(g_currentRegion, g_currentCountry)
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
	
	-- request the correct map
	mapView = native.newWebView( g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2] )
	mapView:request( string.format("%s-map.html", region), system.DocumentsDirectory )
	
	mapView:addEventListener( "urlRequest", webViewListener )
end

-- loads information into the background when a region/country is clicked
function loadInformation(region, country)
	
	-- world information (load details)
	if region == 'World' then
		info_Region.text = "Legal Climates around the World"
		info_Details.text = "Please click on a country to view it's details."
		info_Additional.text = ""
	-- country is selected, load the details!
	elseif country ~= nil then
		info_Region.text = string.format("%s - Rating: %s", country, g_countries[region][country]['Rating'])
		
		local line = "Country Characteristics:\n"
		
		-- start looping through all characteristics for this country
		for key, value in pairs(g_countryCharacteristic) do
			if key ~= 'Rating' and key ~= 'Additional Information' then
				print(key .. " - " .. g_countrySetting[g_countries[region][country][key]])
				line = line .. '\n' .. key .. " - " .. g_countrySetting[g_countries[region][country][key]]
			end
		end
		
		info_Details.text = line
		info_Additional.text = "Information:\n\n" .. g_countries[region][country]['Additional Information']
	else
		info_Region.text = string.format("%s", region)
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
local searchField
local function onSearch( event )
	
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
	
    elseif ( event.phase == "submitted" ) then
	
        if event.target.text ~= nil then
			local result = searchForCountry(event.target.text)
			
			-- found the country!
			if result ~= nil then
				
				-- load map only if it is in a different region
				if g_currentRegion ~= result[1] then
					loadMap(result[1])
				end
				
				-- same again, load information only if it isn't the same country
				if g_currentCountry ~= result[1] then
					loadInformation(result[1], result[2])
				end
				
				-- set our current region and country
				g_currentRegion = result[1]
				g_currentCountry = result[2]
			else
				print("Country was not found...")
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
			searchField = native.newTextField( display.contentCenterX, g_iconSeparation[2], g_contentWidth - 30 - 4 * ( g_iconSeparation[1] + g_iconSize ), 50 )
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
		
		if g_currentUser ~= nil and g_currentCountry ~= nil then
			if editButton.isVisible == true then
				editButton.isVisible = false
			else
				editButton.isVisible = true
			end
		end
	end
end


---------------------------------------------------------------------
-- EDIT BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleEditButton( event )
	
    if ( "ended" == event.phase ) then
        print("Edit Button was pressed!")
		
		-- just to make sure that admin is logged in
		if g_currentUser ~= nil then
			print("GOING TO EDIT PAGE")
		end
	end
end


---------------------------------------------------------------------
-- BACK BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleBackButton( event )
	
    if ( "ended" == event.phase ) then
        print("Back button was pressed!")
		
		if g_currentRegion ~= 'World' or g_currentCountry ~= nil then
			g_currentRegion = 'World'
			g_currentCountry = nil
			
			g_mapView_hidden = false
			
			loadMap(g_currentRegion)
			loadInformation(g_currentRegion, g_currentCountry)
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	sceneGroup:insert(infoContainer)
	
	--[[local infoBackground = display.newRect(g_mapView_defaultCoordinates[1], g_mapView_defaultCoordinates[2], g_mapView_size[1], g_mapView_size[2])
	infoBackground:setFillColor(0.5)
	
	sceneGroup:insert(infoBackground)]]--
	
	info_Region = display.newText('Legal Climates around the World', display.contentCenterX, g_iconSeparation[2], native.systemFont, 16)
	info_Region:setFillColor(1,1,1)
	
	infoContainer:insert(info_Region)
	
	-- country detail information
	info_Details = display.newText("Please click on a country to view it's details.", display.contentCenterX - ( g_contentWidth / 4 ) , g_mapView_defaultCoordinates[2], ( g_mapView_size[1] / 2 ) - 50, g_mapView_size[2] - 50, native.systemFont, 16 )
	info_Details.align = "left"
	
	info_Details:setFillColor(1, 0, 0)
	
	infoContainer:insert(info_Details)
	
	-- additional information
	info_Additional = display.newText("...", display.contentCenterX + ( g_contentWidth / 4 ) , g_mapView_defaultCoordinates[2], ( g_mapView_size[1] / 2 ) - 50, g_mapView_size[2] - 50, native.systemFont, 16 )
	info_Additional.align = "left"
	
	info_Additional:setFillColor(1, 1, 1)
	
	infoContainer:insert(info_Additional)
	
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
			defaultFile = "info-icon.png",
			overFile = "info-icon.png",
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
	
	-- Edit button
	editButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "edit-icon.png",
			overFile = "edit-icon.png",
			onEvent = handleEditButton
		}
	)

	-- place the button
	editButton.x = g_contentWidth - g_iconSize - g_iconSeparation[2]
	editButton.y = g_contentHeight - g_iconSeparation[2]
	
	editButton.isVisible = false
	
	sceneGroup:insert(editButton)
	
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