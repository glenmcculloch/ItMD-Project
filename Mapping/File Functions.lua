-----------------------------------------------------------------------------------------
--
-- Global Functions used by program
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


-----------------------------------------------------------------------------------------
--
-- File-Related functions
--
-----------------------------------------------------------------------------------------

-- Function to load specific country settings from file
--  (if not found it defaults to nil for each characteristic)
function loadCountryData(region, country)
	local path = system.pathForFile(string.format("%s.data", country), system.DocumentsDirectory)
	local file, errorString = io.open(path, "r")
	
	local result = {}

	if file then
		print("FOUND FILE")
		local s
		for line in io.lines(path) do
			if line:len() ~= 0 then
				-- split the line (format characteristic=value)
				s = split(line, "=")
				
				if s[1] == "Additional Information" then
					result[s[1]] = s[2]
				else
					result[s[1]] = tonumber(s[2])
				end
			end
		end
		io.close(file)
	else
		result = g_countryCharacteristic
	end
	
	file = nil
	return result
end

-- Function to load countries from file (for searches and saved data)
function saveCountryData(region, country)
	local path = system.pathForFile(string.format("%s.data", country), system.DocumentsDirectory)
	local file, errorString = io.open(path, "w")

	if not file then
		print("File error: " .. errorString)
	else
		local line
		for key,value in pairs(g_countries[region][country]) do
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

-- Function that searches for a specific country and returns either nil or a table of that country's characteristics
function searchForCountry(country)
	local result
	
	-- capitalises each first letter and the rest to lower case (matches our countries datastructure)
	country = string.gsub(" "..string.lower(country), "%W%l", string.upper):sub(2)
	print(country)
	
	-- search through all regions for country
	for key,value in pairs(g_countries) do
		if g_countries[key][country] ~= nil then
			result = {key, country}
			break
		end
	end
	
	return result
end

-- Function to set a country's characteristics value
--  IDEA: have a drop-down menu with the values: No data, Present, Not present
--         in the edit country details page
function setCountryData(region, country, characteristic)
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
function getCountryRating(region, country)
	-- default rating is 0 (no data)
	local rating = 0
	
	--[[CODE TO ADD (EXAMPLE)
	
	if torture_present then
		rating = ???
	elseif incarceration_present then
		rating = ???
	end
	
	return rating
	]]--
end

-- Function that creates an html page for our webview. This will be saved in documents directory
function createWorldMap()
	local path = system.pathForFile("World-map.html", system.DocumentsDirectory)
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
			region: 'world',
			resolution: 'continents', 
			colorAxis: {
			colors: [
				'red', // 1
				'orange', // 2
				'cyan', // 3
				'purple', // 4
				'yellow', // 5
				], 
				values: [1,2,3,4,5]
			},
			backgroundColor: '#000000',
			legend: 'none',
			tooltip: {trigger: 'none'},
			width: %d, 
			height: %d, 
			keepAspectRatio: false
		};
		var data = google.visualization.arrayToDataTable([
			['Region code', 'Continent', 'Value'] ,
			['002', 'Africa', 1] ,
			['150', 'Europe', 2] ,
			['019', 'Americas', 3] ,
			['142', 'Asia', 4] ,
			['009', 'Oceania', 5]
		]);
		
		var chart = new google.visualization.GeoChart(document.getElementById('geochart-colors'));
		
		google.visualization.events.addListener(chart, 'select', function(e) {
			var selection = chart.getSelection();
			if (selection.length == 1) {
				var selectedRow = selection[0].row;
				var selectedRegion = data.getFormattedValue(selection[0].row, 1);
				
				var link = "region:" + selectedRegion;
				
				document.getElementById("region").href=link;
				document.getElementById("region").click();
			}
		});
		
		chart.draw(data, options);
	}
	
	</script>
  </head>
  <body style="background:black">
	<div id="geochart-colors"></div>
	<a id="region" href=""></a>
  </body>
</html>]], g_mapView_size[1] - 10, g_mapView_size[2] - 10)
		
		file:write(line)
		file:close()
	end
	
	file = nil
end

-- Function that creates an html page for our webview. This will be saved in documents directory
function createRegionMap(region)
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
			backgroundColor: '#000000',
			displayMode: 'regions',
			datalessRegionColor: '#0000FF',
			defaultColor: '#000000',
			tooltip: {trigger: 'none'},
			legend: 'none',
			keepAspectRatio: true
		};
		
		var data = google.visualization.arrayToDataTable([
			['Country', 'Rating'] ]], g_regionId[region], g_contentHeight)
		
		file:write(line)
		
		-- start looping through all countries within that region
		for key, value in pairs(g_countries) do
			if key == region then
				for key_2, value_2 in pairs(value) do
					line = string.format([[,
			['%s', %s] ]], key_2, g_countries[key][key_2]['Rating'])
					
					file:write(line)
				end
			end
		end
		
		-- end of file stuff
		line = string.format([[
		
		]);
		
		var chart = new google.visualization.GeoChart(document.getElementById('geochart-colors'));
		
		google.visualization.events.addListener(chart, 'select', function(e) {
			var selection = chart.getSelection();
			if (selection.length == 1) {
				var selectedRow = selection[0].row;
				var selectedRegion = data.getFormattedValue(selection[0].row, 0);
				
				var link = "country:" + selectedRegion;
				
				document.getElementById("country").href=link;
				document.getElementById("country").click();
			}
		});
		
		chart.draw(data, options);
	}
	
	</script>
  </head>
  <body style="background:black">
	<div id="geochart-colors"></div>
	<a id="country" href=""></a>
  </body>
</html>]], 1000, 500)
		
		file:write(line)
		file:close()
	end
	
	file = nil
end

-- Function to load countries from file (for searches and saved data)
function loadCountries()
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
					g_countries[region] = {}
				elseif region ~= nil then
					g_countries[region][line] = loadCountryData(region, line)
				end
			end
		end
		io.close( file )
	end
	
	file = nil
end

-- Function to load countries from file (for searches and saved data)
function loadCountryCodes()

	local path = system.pathForFile("country_codes.txt", system.ResourceDirectory)
	local file, errorString = io.open(path, "r")

	if not file then
		print("File error: " .. errorString)
	else
		local line, data
		-- iterate through each line in the file
		for line in io.lines(path) do
			-- length is 0, ignore this line
			if line:len() ~= 0 then
				data = split(line, ":")
				
				g_countryCodes[data[1]] = data[2]
			end
		end
		io.close( file )
	end
	
	file = nil
end

-- Function to load all admins from the file into the application
function loadAdmins()

	local path = system.pathForFile("admins.txt", system.ResourceDirectory)
	local file, errorString = io.open(path, "r")
	
	if not file then
		print("File error: " .. errorString)
	else
		local line, data
		local iter = 1
		
		-- iterate through each line in the file
		for line in io.lines(path) do
			-- length is 0, ignore this line
			if line:len() ~= 0 then
				data = split(line, ":")
				
				g_admins[data[1]] = {}
				
				g_admins[data[1]].password = data[2]
				g_admins[data[1]].name = data[3]
				
				iter = iter + 1
			end
		end
		io.close( file )
		
		print(string.format("Loaded (%d) admins", iter - 1))
	end
	
	file = nil
end