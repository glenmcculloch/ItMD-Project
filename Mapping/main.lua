-----------------------------------------------------------------------------------------
--
-- The main screen for our program!
--
-----------------------------------------------------------------------------------------
local composer = require( "File Functions" )
local composer = require( "composer" )

-- holds all country data for our program
g_admins = {}
g_countries = {}

g_regionId = {
	['Africa'] = '002', 
	['Europe'] = '150', 
	['Americas'] = '019', 
	['Asia'] = '142',
	['Oceania'] = '009'
}

g_countrySetting = {
	[1] = "???", 
	[2] = "No", 
	[3] = "Yes"
}

-- all country characteristics with default values
g_countryCharacteristics = {
	[1] = {id='Rating', default=0},
	[2] = {id='Torture', default=1},
	[3] = {id='Death Penalty', default=1},
	[4] = {id='Conflict', default=1},
	[5] = {id='State Oppression', default=1},
	[6] = {id='Legal Torture', default=1}
}
MAX_CHARACTERISTICS = 6

-- Device content height and width
g_contentHeight = display.actualContentHeight
g_contentWidth = display.actualContentWidth

-- Variables about selections and current status
g_currentUser = nil
g_currentRegion = 'World'
g_currentCountry = nil

-- Setup our map details
g_mapView_size = {g_contentWidth, g_contentHeight - (g_contentHeight / 8)}
g_mapView_defaultCoordinates = {display.contentCenterX, display.contentCenterY + (g_contentHeight / 8)}
g_mapView_hideCoordinates = {display.contentCenterX, g_mapView_defaultCoordinates[2] + g_mapView_size[2]}
g_mapView_hidden = false

-- Miscellaneous
g_transitionTime = 1000	-- time for map shifts and other stuff
g_iconSize = 40
g_iconSeparation = {10, 30}


-----------------------------------------------------------------------------------------
--
-- Loading area
--
-----------------------------------------------------------------------------------------
local loadingText = display.newText({
	text = "Loading Application", 
	x = display.contentCenterX, 
	y = display.contentCenterY, 
	font = native.systemFontBold, 
	fontSize = 20
})

loadAdmins()
loadCountries()

--Create all map files!
for key,value in pairs(g_regionId) do
	createRegionMap(key)
end

createWorldMap()

-- for key,value in pairs(g_countries) do
	-- createCountryMap(key)
-- end

local function startApplication( event )
	loadingText:removeSelf()
	loadingText = nil
	composer.gotoScene("mapScene")
end

-- to make sure??? (doesn't seem to do anything
timer.performWithDelay( 5000, startApplication )


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

--[[
---------------------------------------------------------------------
-- SEARCH BUTTON AND FIELD
---------------------------------------------------------------------
function searchListener( event )
	
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
function handleSearchButton( event )
	
    if ( "ended" == event.phase ) then
		searchField = native.newTextField( display.contentCenterX, 0, g_contentWidth - 100, 50 )
		searchField:addEventListener( "userInput", searchListener )
    end
end
 
-- Create the widget
searchButton = widget.newButton(
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
function handleLoginButton( event )
	
    if ( "ended" == event.phase ) then
        print("Login Button was pressed!")
    end
end

-- Create the widget
loginButton = widget.newButton(
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
function handleEditButton( event )
	
    if ( "ended" == event.phase ) then
        print("Edit Button was pressed!")
		
		if g_currentRegion ~= nil then
			if g_mapView_hidden == false then
				g_mapView_hidden = true
				transition.moveTo(g_countryView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=400 })
			else
				g_mapView_hidden = false
				transition.moveTo(g_countryView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=400 })
			end
		else
			if g_mapView_hidden == false then
				g_mapView_hidden = true
				transition.moveTo(g_worldView, { x=g_mapView_hideCoordinates[1], y=g_mapView_hideCoordinates[2], time=400 })
			else
				g_mapView_hidden = false
				transition.moveTo(g_worldView, { x=g_mapView_defaultCoordinates[1], y=g_mapView_defaultCoordinates[2], time=400 })
			end
		end
	end
end

-- Create the widget
editButton = widget.newButton(
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


---------------------------------------------------------------------
-- BACK BUTTON
---------------------------------------------------------------------
-- Function to handle button events
function handleBackButton( event )
	
    if ( "ended" == event.phase ) then
        print("Back button was pressed!")
		
		if g_currentRegion ~= nil then
			g_currentRegion = nil
			
			g_worldView.isVisible = true
			composer.removeScene("mapScene")
		end
	end
end

-- Create the widget
backButton = widget.newButton(
    {
        width = 40,
        height = 40,
        defaultFile = "back-icon.png",
        overFile = "back-icon.png",
        onEvent = handleBackButton
    }
)

-- Center the button
backButton.x = 0
backButton.y = g_contentHeight - 50

g_displayMenu:insert(backButton)]]--