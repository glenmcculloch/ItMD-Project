-----------------------------------------------------------------------------------------
--
-- The main screen for our program!
--
-----------------------------------------------------------------------------------------
local composer = require( "File Functions" )

-- holds all country data for our program
admins = {}
countries = {}
country_codes = {}

region_id = {
	['Africa'] = '002', 
	['Europe'] = '150', 
	['Americas'] = '019', 
	['Asia'] = '142',
	['Oceania'] = '009'
}

country_setting = {
	"...", 	-- 0
	"No", 	-- 1
	"Yes"	-- 2
}

-- all country characteristics with default values
country_characteristic = {
	['Torture'] = 0, 
	['Death Penalty'] = 0, 
	['Conflict'] = 0, 
	['State of Oppression'] = 0, 
	['Legal Torture'] = 0, 
	['Additional Information'] = "..."
}

content_height = display.actualContentHeight
content_width = display.actualContentWidth

current_region = nil

-----------------------------------------------------------------------------------------
--
-- Loading area
--
-----------------------------------------------------------------------------------------
loadAdmins()
loadCountries()
loadCountryCodes()

-- Create all map files!
for key,value in pairs(countries) do
	print(string.format("Creating region map (%s)", key))
	createHTMLFile(key)
end


-----------------------------------------------------------------------------------------
--
-- Buttons and UI
--
-----------------------------------------------------------------------------------------
display.setDefault( "background", 0, 0, 0 )

local button_height = content_height / 12
local button_width = content_width * 0.60

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

local y_coord = display.contentCenterY - content_height / 10

-- iterate through the buttons and get their x coordinate
for key,value in pairs(countries) do
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
 
    if ( "ended" == event.phase ) then
        print( "Asia Button was pressed and released" )
        composer.gotoScene("asiaMapScene")
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
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        composer.gotoScene("africaMapScene")
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
 
    if ( "ended" == event.phase ) then
        print( "Europe Button was pressed and released" )
        composer.gotoScene("europeMapScene")


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
 
    if ( "ended" == event.phase ) then
        print( "Americas Button was pressed and released" )
        composer.gotoScene("americasMapScene")
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
 
    if ( "ended" == event.phase ) then
        print( " Oceania Button was pressed and released" )
        composer.gotoScene("oceaniaMapScene")
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