-----------------------------------------------------------------------------------------
--
-- Global Functions used by program
--
-----------------------------------------------------------------------------------------

-- Function to split a string given a token
function split(s, token)
    result = {}
    for match in (s..token):gmatch("(.-)"..token) do
        table.insert(result, match)
    end
    return result
end

-- capitalises the first letter of every word in a string
function capitalise(s)
	return string.gsub(" "..string.lower(s), "%W%l", string.upper):sub(2)
end


-----------------------------------------------------------------------------------------
--
-- File-Related functions
--
-----------------------------------------------------------------------------------------

-- Function to load specific country settings from file
--  (if not found it defaults to nil for each characteristic)
function loadCountryData(country)
	local path = system.pathForFile(string.format("%s.data", country), system.DocumentsDirectory)
	local file, errorString = io.open(path, "r")
	
	-- initialise our data structure
	g_countries[country]['data'] = {}
	g_countries[country]['info'] = "..."
	g_countries[country]['rating'] = 0
	
	if file then
		local data, characteristic, value
		local isInfo = false
		local info = ""
		
		for line in io.lines(path) do
			-- start reading information in
			if line == "[info]" then
				-- stop reading information
				if isInfo then
					g_countries[country]['info'] = info
					isInfo = false
				else
					isInfo = true
				end
			-- reading information in
			elseif isInfo then
				info = info..line
				print(info)
			-- normal characteristic, read it in
			else
				data = split(line, "=")
				
				characteristic = data[1]
				value = data[2]
				
				if characteristic == 'Rating' then
					g_countries[country]['rating'] = tonumber(value)
				else
					g_countries[country]['data'][characteristic] = tonumber(value)
				end
			end
		end
		io.close(file)
	else
		-- initialise values to nil if we can't load from file
		for key,value in pairs(g_countryCharacteristics) do
			g_countries[country]['data'][value.id] = value.default
		end
	end
	
	file = nil
end

-- Function to load countries from file (for searches and saved data)
function saveCountryData(country, rating, data, info)
	local path = system.pathForFile(string.format("%s.data", country), system.DocumentsDirectory)
	local file, errorString = io.open(path, "w")
	
	if not file then
		print("File error: " .. errorString)
		
		return false
	else
		file:write(string.format("Rating=%s\n", rating))
		
		for key,value in pairs(data) do
			file:write(string.format("%s=%d\n", key, value))
		end
		
		file:write(string.format("[info]\n%s\n[info]", info))
		
		file:close()
	end
	
	file = nil
	
	g_countries[country]['rating'] = rating
	g_countries[country]['data'] = data
	g_countries[country]['info'] = info
	
	createCountryMap(country)
	return true
end

-- Function that searches for a specific country and returns either nil or a table of that country's characteristics
function searchForCountry(country)
	local result
	
	-- capitalises each first letter and the rest to lower case (matches our countries data structure)
	country = capitalise(country)
	
	-- search through all regions for country
	if g_countries[country] ~= nil then
		result = {g_countries[country].region, country}
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
	<div style="margin:auto" id="geochart-colors"></div>
	<a id="region" href=""></a>
  </body>
</html>]], g_mapView_size[1], g_mapView_size[2])
		
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
			width: %d,
			keepAspectRatio: true
		};
		
		var data = google.visualization.arrayToDataTable([
			['Region', 'Country', 'Rating'] ]], g_regionId[region], 1000)
		
		file:write(line)
		
		-- start looping through all countries within that region
		for key,value in pairs(g_countries) do
			if value.region == region then
				line = string.format([[,
			["%s", "%s", %d] ]], value.code, value.name, value.rating)
				
				file:write(line)
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
	<div id="geochart-colors" style="margin:auto"></div>
	<a id="country" href=""></a>
  </body>
</html>]])
		
		file:write(line)
		file:close()
	end
	
	file = nil
end

-- Function that creates an html page for our webview. This will be saved in documents directory
function createCountryMap(country)
	local path = system.pathForFile(string.format("%s-map.html", country), system.DocumentsDirectory)
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
			resolution: 'countries',
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
			keepAspectRatio: true,
			width: %s
		};
		
		var data = google.visualization.arrayToDataTable([
			['Region code', 'Country', 'Rating'], 
			['%s', '%s', %d]
		]);]], g_countries[country].code, g_contentHeight, g_countries[country].code, country, g_countries[country].rating)
		
		file:write(line)
		
		-- end of file stuff
		line = string.format([[
		
		var chart = new google.visualization.GeoChart(document.getElementById('geochart-colors'));
		
		chart.draw(data, options);
	}
	
	</script>
  </head>
  <body style="background:black">
	<div style="margin:auto" id="geochart-colors"></div>
	<a id="country" href=""></a>
  </body>
</html>]])
		
		file:write(line)
		file:close()
	end
	
	file = nil
end

-- Function to load countries from file (for searches and saved data)
function loadCountries()
	local path = system.pathForFile("countries.txt", system.ResourceDirectory)
	local file, errorString = io.open(path, "r")

	if not file then
		print("File error: " .. errorString)
	else
		local data
		local country, region, code
		-- iterate through each line in the file
		for line in io.lines(path) do
			-- length is 0, ignore this line
			if line:len() ~= 0 then
				-- line includes a region
				data = split(line, ":")
				
				country = data[1]
				region = data[2]
				code = data[3]
				
				g_countries[country] = {
					name=country, 
					region=region, 
					code=code
				}
				
				loadCountryData(country)
				
				-- this will be used to easily find a country given it's country code
				--  (like a reverse lookup table)
				g_codeToCountry[code] = country
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