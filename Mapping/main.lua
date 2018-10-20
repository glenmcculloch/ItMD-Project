-----------------------------------------------------------------------------------------
--
-- The main screen for our program!
--
-----------------------------------------------------------------------------------------




display.setDefault( "background", 0, 9, 8 )

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
local Asiabutton = widget.newButton(
    {
        label = "button",
        onEvent = handleAsiaButton,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)
 
-- Center the button
Asiabutton.x = display.contentCenterX 
Asiabutton.y = display.contentCenterY - 150
 
-- Change the button's label text
Asiabutton:setLabel( "Asia" )


-------------------------------------------------------------------------

-- Function to handle button events
local function handleAfricaButton( event )
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        composer.gotoScene("africaMapScene")
    end
end
 
-- Create the widget
local Africabutton = widget.newButton(
    {
        label = "button",
        onEvent = handleAfricaButton,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)
 
-- Center the button
Africabutton.x = display.contentCenterX 
Africabutton.y = display.contentCenterY - 50
 
-- Change the button's label text
Africabutton:setLabel( "Africa" )


-----------------------------------------------------------

-- Function to handle button events
local function handleEuropeButton( event )
 
    if ( "ended" == event.phase ) then
        print( "Europe Button was pressed and released" )
        composer.gotoScene("europeMapScene")


    end
end
 
-- Create the widget
local Europebutton = widget.newButton(
    {
        label = "button",
        onEvent = handleEuropeButton,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)
 
-- Center the button
Europebutton.x = display.contentCenterX 
Europebutton.y = display.contentCenterY - -40
 
-- Change the button's label text
Europebutton:setLabel( "Europe" )


----------------------------------------------------------------

-- Function to handle button events
local function handleAmericasButton( event )
 
    if ( "ended" == event.phase ) then
        print( "Americas Button was pressed and released" )
        composer.gotoScene("americasMapScene")
    end
end
 
-- Create the widget
local Americasbutton = widget.newButton(
    {
        label = "button",
        onEvent = handleAmericasButton,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)
 
-- Center the button
Americasbutton.x = display.contentCenterX 
Americasbutton.y = display.contentCenterY - -120
 
-- Change the button's label text
Americasbutton:setLabel( "Americas" )


---------------------------------------------------------------------

-- Function to handle button events
local function handleOceaniaButton( event )
 
    if ( "ended" == event.phase ) then
        print( " Oceania Button was pressed and released" )
        composer.gotoScene("oceaniaMapScene")
    end
end
 
-- Create the widget
local Oceniabutton = widget.newButton(
    {
        label = "button",
        onEvent = handleOceaniaButton,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)
 
-- Center the button
Oceniabutton.x = display.contentCenterX 
Oceniabutton.y = display.contentCenterY - -200
 
-- Change the button's label text
Oceniabutton:setLabel( "Oceania" )