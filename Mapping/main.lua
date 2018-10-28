-----------------------------------------------------------------------------------------
--
-- The main screen for our program!
--
-----------------------------------------------------------------------------------------
local composer = require( "File Functions" )
local widget = require( "widget" )
local composer = require( "composer" )

-- holds all country data for our program
g_admins = {}
g_countries = {}
g_countryCodes = {}

g_regionId = {
	['Africa'] = '002', 
	['Europe'] = '150', 
	['Americas'] = '019', 
	['Asia'] = '142',
	['Oceania'] = '009'
}

g_countrySetting = {
	"...", 	-- 0
	"No", 	-- 1
	"Yes"	-- 2
}

-- all country characteristics with default values
g_countryCharacteristic = {
	['Torture'] = 0, 
	['Death Penalty'] = 0, 
	['Conflict'] = 0, 
	['State of Oppression'] = 0, 
	['Legal Torture'] = 0, 
	['Additional Information'] = "..."
}

g_contentHeight = display.actualContentHeight
g_contentWidth = display.actualContentWidth

g_currentRegion = nil

g_displayMenu = display.newGroup()

g_mapView_defaultCoordinates = {display.contentCenterX + 50, display.contentCenterY}
g_mapView_hideCoordinates = {g_contentWidth + (g_contentWidth / 5), display.contentCenterY}
g_mapView_hidden = false


-----------------------------------------------------------------------------------------
--
-- Loading area
--
-----------------------------------------------------------------------------------------
loadAdmins()
loadCountries()
loadCountryCodes()

-- Create all map files!
for key,value in pairs(g_countries) do
	print(string.format("Creating region map (%s)", key))
	createHTMLFile(key)
end

--[[LOAD THE MAIN MAP]]--

local mapView = native.newWebView( display.contentCenterX + 50, display.contentCenterY, g_contentWidth - 100, g_contentHeight)
mapView:request( "World-map.html", system.ResourceDirectory )

local function webViewListener(event)

	-- a region was clicked
	if event.url and event.type == "other" then
		local data = string.gsub(event.url, "%%20", " ")
		data = split(data, ":")
		
		print(data[2])
	end
end

mapView:addEventListener( "urlRequest", webViewListener )


-----------------------------------------------------------------------------------------
--
-- Buttons and UI
--
-----------------------------------------------------------------------------------------
--[[display.setDefault( "background", 0.2, 0.2, 0.2 )

local button_height = g_contentHeight / 12
local button_width = g_contentWidth * 0.60

local buttonPositions = {}

local buttonOptions = {
	label = "button",
	emboss = false,
	-- Properties for a rounded rectangle button
	shape = "roundedRect",
	width = button_width,
	height = button_height,
	cornerRadius = 5,
	fillColor = { default={1,1,1,0.5}, over={1,1,1,0.5} },
	strokeColor = { default={1,1,1,0.9}, over={1,1,1,0.9} },
	strokeWidth = 4
}

local y_coord = display.contentCenterY - g_contentHeight / 10

-- iterate through the buttons and get their x coordinate
for key,value in pairs(g_countries) do
	buttonPositions[key] = y_coord
	
	y_coord = y_coord + button_height + 20
end


-----------------------------------------------------------------------------------------
--
-- Region Buttons
--
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )

-- Function to handle button events
local function handleAsiaButton( event )
	g_currentRegion = 'Asia'
 
    if ( "ended" == event.phase ) then
        print( "Asia Button was pressed and released" )
        composer.gotoScene("mapScene")
    end
end

-- Create the widget
buttonOptions.onEvent = handleAsiaButton
local asiaButton = widget.newButton(buttonOptions)
 
-- Center the button
asiaButton.x = display.contentCenterX
asiaButton.y = buttonPositions['Asia']
 
-- Change the button's label text
asiaButton:setLabel( "Asia" )


-------------------------------------------------------------------------

-- Function to handle button events
local function handleAfricaButton( event )
	g_currentRegion = 'Africa'
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        composer.gotoScene("mapScene")
    end
end
 
-- Create the widget
buttonOptions.onEvent = handleAfricaButton
local africaButton = widget.newButton(buttonOptions)

-- Center the button
africaButton.x = display.contentCenterX
africaButton.y = buttonPositions['Africa']
 
-- Change the button's label text
africaButton:setLabel( "Africa" )


-----------------------------------------------------------

-- Function to handle button events
local function handleEuropeButton( event )
	g_currentRegion = 'Europe'
 
    if ( "ended" == event.phase ) then
        print( "Europe Button was pressed and released" )
        composer.gotoScene("mapScene")


    end
end
 
-- Create the widget
buttonOptions.onEvent = handleEuropeButton
local europeButton = widget.newButton(buttonOptions)
 
-- Center the button
europeButton.x = display.contentCenterX
europeButton.y = buttonPositions['Europe']
 
-- Change the button's label text
europeButton:setLabel( "Europe" )


----------------------------------------------------------------

-- Function to handle button events
local function handleAmericasButton( event )
	g_currentRegion = 'Americas'
 
    if ( "ended" == event.phase ) then
        print( "Americas Button was pressed and released" )
        composer.gotoScene("mapScene")
    end
end
 
-- Create the widget
buttonOptions.onEvent = handleAmericasButton
local americasButton = widget.newButton(buttonOptions)

-- Center the button
americasButton.x = display.contentCenterX
americasButton.y = buttonPositions['Americas']
 
-- Change the button's label text
americasButton:setLabel( "Americas" )


---------------------------------------------------------------------

-- Function to handle button events
local function handleOceaniaButton( event )
	g_currentRegion = 'Oceania'
 
    if ( "ended" == event.phase ) then
        print( " Oceania Button was pressed and released" )
        composer.gotoScene("mapScene")
    end
end
 
-- Create the widget
buttonOptions.onEvent = handleOceaniaButton
local oceaniaButton = widget.newButton(buttonOptions)
 
-- Center the button
oceaniaButton.x = display.contentCenterX
oceaniaButton.y = buttonPositions['Oceania']
 
-- Change the button's label text
oceaniaButton:setLabel( "Oceania" )

--]]


---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
local searchField

local function searchListener( event )
	
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
	
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( event.target.text )
		
		local result = searchForCountry(event.target.text, nil)
		if found ~= nil then
			g_currentRegion = result
			composer.gotoScene("mapScene")
		else
			print("Country was not found...")
		end
		
		searchField:removeSelf()
    end
end

-- Function to handle button events
local function handleSearchButton( event )
	
    if ( "ended" == event.phase ) then
		searchField = native.newTextField( display.contentCenterX, 0, g_contentWidth - 100, 50 )
		searchField:addEventListener( "userInput", searchListener )
    end
end
 
-- Create the widget
local searchButton = widget.newButton(
    {
        width = 40,
        height = 40,
        defaultFile = "search-icon.png",
        overFile = "search-icon.png",
        onEvent = handleSearchButton
    }
)
-- Center the button
searchButton.x = 0
searchButton.y = 30

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
        width = 40,
        height = 40,
        defaultFile = "user-icon.png",
        overFile = "user-icon.png",
        onEvent = handleLoginButton
    }
)
-- Center the button
loginButton.x = 0
loginButton.y = 80

g_displayMenu:insert(loginButton)


---------------------------------------------------------------------
-- EDIT BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleEditButton( event )
	
    if ( "ended" == event.phase ) then
        print("Edit Button was pressed!")
		
		if g_mapView_hidden == false then
			g_mapView_hidden = true
			transition.moveTo(mapView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=400 })
		else
			g_mapView_hidden = false
			transition.moveTo(mapView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=400 })
		end
	end
end

-- Create the widget
local editButton = widget.newButton(
    {
        width = 40,
        height = 40,
        defaultFile = "edit-icon.png",
        overFile = "edit-icon.png",
        onEvent = handleEditButton
    }
)
-- Center the button
editButton.x = 0
editButton.y = 130

g_displayMenu:insert(editButton)