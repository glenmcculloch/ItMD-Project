-----------------------------------------------------------------------------------------
--
-- The main screen for our program!
--
-----------------------------------------------------------------------------------------

-- holds all country data for our program
countries = {}

region_id = {
	['Africa'] = '002', 
	['Europe'] = '150', 
	['Americas'] = '019', 
	['Asia'] = '142',
	['Oceania'] = '009'
}

-- all country characteristics
country_characteristic = {
	['Torture'] = nil, 
	['Death Penalty'] = nil, 
	['Conflict'] = nil, 
	['State of Oppression'] = nil, 
	['Legal Torture'] = nil
}

content_height = display.actualContentHeight
content_width = display.actualContentWidth

-----------------------------------------------------------------------------------------
--
-- File-Related functions
--
-----------------------------------------------------------------------------------------

-- Function to split a string given a token
function split(s, token)
    result = {};
    for match in (s..token):gmatch("(.-)"..token) do
        table.insert(result, match);
    end
    return result;
end

-- Function to load countries from file (for searches and saved data)
local function loadCountries()
	local path = system.pathForFile("countryList.txt", system.ResourceDirectory)
	local file, errorString = io.open(path, "r")

	if not file then
		print("File error: " .. errorString)
	else
		local region
		-- iterate through each line in the file
		for line in io.lines(path) do
			-- length is 0, ignore this line
			if line:len() ~= 0 then
				-- line includes a region
				if string.find(line, "%[") ~= nil then
					-- remove [ and ]
					line = string.gsub(line, "%[", '')
					line = string.gsub(line, "%]", '')
					
					region = line
					
					-- initialise region table
					countries[region] = {}
				elseif region ~= nil then
					countries[region][line] = loadCountryData(region, line)
				end
			end
		end
		io.close( file )
	end
	
	file = nil
end

-- Function to load specific country settings from file
--  (if not found it defaults to nil for each characteristic)
local function loadCountryData(region, country)
	local path = system.pathForFile(string.format("%s.data", country), system.DocumentsDirectory)
	local file, errorString = io.open(path, "r")
	
	local result = {}

	if file then
		local s
		for line in io.lines(path) do
			if line:len() ~= 0 then
				-- split the line (format characteristic=value)
				s = split(line, "=")
				
				if s[1] == "Additional Information" then
					result[s[1]] = s[2]
				elseif s[2] == "nil" then
					result[s[1]] = nil
				elseif s[2] == "true" then
					result[s[1]] = true
				elseif s[2] == "false" then
					result[s[1]] = false
				end
			end
		end
		io.close(file)
	else
		result = country_characteristic
	end
	
	file = nil
	return result
end

-- Function to load countries from file (for searches and saved data)
local function saveCountryData(region, country)
	local path = system.pathForFile(string.format("%s.data", country), system.DocumentsDirectory)
	local file, errorString = io.open(path, "w")

	if not file then
		print("File error: " .. errorString)
	else
		local line
		for key,value in pairs(countries[region][country]) do
			if key == "Additional Information" then
				file:write(string.format("Additional Information=%s", value))
			elseif value == nil then
				file:write(string.format("%s=nil", key))
			elseif value == true then
				file:write(string.format("%s=true", key))
			elseif value == false then
				file:write(string.format("%s=false", key))
			end
		end
		
		file:close()
	end
	
	file = nil
end

-- Function to set a country's characteristics value
--  IDEA: have a drop-down menu with the values: No data, Present, Not present
--         in the edit country details page
local function setCountryData(region, country, characteristic)
	-- TO DO: get values from edit-country form and set the characteristics
	
	--[[
	countries[region][country][characteristic] = torture_field_value
	countries[region][country][characteristic] = deathpenalty_field_value
	...
	saveCountryData(region, country)
	]]--
end

-- This function is used to determine a country's rating depending on its characteristics
--  WE NEED TO GET CHARACTERISTIC VALUES FROM THE CLIENT TO COMPLETE THIS
--   RIGHT NOW RATINGS ARE DETERMINED RANDOMLY ON APPLICATION STARTUP
local function getCountryRating(region, country)
	-- default rating is 0 (no data)
	local rating = 0
	
	--[[CODE TO ADD]]--
end

-- Function that creates an html page for our webview. This will be saved in documents directory
--  and be used for our webview
local function createHTMLFile(region)
	local path = system.pathForFile(string.format("%s-map.html", region), system.DocumentsDirectory)
	local file, errorString = io.open(path, "w")

	if not file then
		print("File error: " .. errorString)
	else
		local line
		
		-- initial startup line
		line = string.format([[
<html>
  <head>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	
	<script type="text/javascript">
	  google.charts.load('current', {
		'packages':['geochart'],
		// Note: you will need to get a mapsApiKey for your project.
		// See: https://developers.google.com/chart/interactive/docs/basic_load_libs#load-settings
		'mapsApiKey': 'AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY'
	  });
	google.charts.setOnLoadCallback(drawVisualisation);
	
	function drawVisualisation() {
		var options = {
			region: '%s',
			colorAxis: {
			colors: [
				'#FFFFFF', // 0
				'#00853F', // 1
				'#3F9B39', // 2
				'#7FB234', // 3
				'#BFC82E', // 4
				'#BFC82E', // 5
				'#F8AE27', // 6
				'#F8AE27', // 7
				'#F17D26', // 8
				'#EA4C24', // 9
				'#E31B23', // 10
				], 
				values: [0,1,2,3,4,5,6,7,8,9,10]
			},
			backgroundColor: '#81d4fa',
			displayMode: 'regions',
			datalessRegionColor: '#0000FF',
			defaultColor: '#f5f5f5',
		};
		
		var data = google.visualization.arrayToDataTable([
			['Country', 'Rating'] ]], region_id[region])
		
		file:write(line)
		
		-- start looping through all countries within that region
		for key, value in pairs(countries) do
			if key == region then
				for key, value in pairs(value) do
					country = string.gsub(key, "% ", "-")
					
					line = string.format([[,
			['%s', %i] ]], key, math.random(0,10))
					
					file:write(line)
				end
			end
		end
		
		-- end of file stuff
		line = string.format([[
		
		]);
		
		var chart = new google.visualization.GeoChart(document.getElementById('geochart-colors'));
		chart.draw(data, options);
	}
	</script>
  </head>
  <body>
	<div id="geochart-colors" style="width: 500px; height: 480px;"></div>
  </body>
</html>]])
		
		file:write(line)
		file:close()
	end
	
	file = nil
end

-- Function that saves our region data to persistent storage
--  (the html file will then load this to colour the map)
local function saveCountryData(region)
	local path = system.pathForFile(string.format("%s-data.xml", region), system.DocumentsDirectory)
	local file, errorString = io.open(path, "w")

	if not file then
		print("File error: " .. errorString)
	else
		local line, country
		
		file:write(string.format("<%s>\n", region))
		
		-- iterate through all countries within the given region
		for key, value in pairs(countries) do
			if key == region then
				for key, value in pairs(value) do
					country = string.gsub(key, "% ", "-")
					
					file:write(string.format("\t<country>\n\t\t<name>%s</name>\n\t\t<rating>%i</rating>\n\t</country>\n", country, math.random(0, 10)))
				end
			end
		end
		
		file:write(string.format("</%s>", region))
		file:close()
	end
	
	file = nil
end

-----------------------------------------------------------------------------------------
--
-- Loading area
--
-----------------------------------------------------------------------------------------

loadCountries()

-- Create all map files!
for key,value in pairs(countries) do
	print(string.format("Creating region map (%s)", key))
	createHTMLFile(key)
end


-----------------------------------------------------------------------------------------
--
-- Buttons and UI (Main code)
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
local Oceaniabutton = widget.newButton(
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
Oceaniabutton.x = display.contentCenterX 
Oceaniabutton.y = display.contentCenterY - -200
 
-- Change the button's label text
Oceaniabutton:setLabel( "Oceania" )