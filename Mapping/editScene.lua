-----------------------------------------------------------------------------------------
--
-- Dynamic Map
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local background
local centerText

local infoText = {}
local infoButton = {}
local infoAdditional

local selectButton
local selectionData
local selectionRating
local selectionInfo

local picker
local pickerStrip
local pickerSelection

local separation = 40

-- save overlay
local options = {
    effect = "fade",
    time = 500,
    isModal = true
}


---------------------------------------------------------------------
-- SPECIFIC FUNCTIONS
---------------------------------------------------------------------
local function openOverlay(type)
	if infoAdditional then
		infoAdditional.isVisible = false
	end
	
	options.params = {type=type}
	composer.showOverlay("editOverlay", options)
end

function scene:closeOverlay(exit)
	
	if exit then
		composer.hideOverlay()
		composer.removeScene(scene)
		
		composer.gotoScene("mapScene")
	else
		composer.hideOverlay( "fade", 400 )
		
		infoAdditional.isVisible = true
	end
end

-- returns the given picker value to a corresponding data value
local function getPickerValue(value)
	local result
	
	if value == "???" then
		result =  1
	elseif value == "Yes" then
		result =  2
	elseif value == "No" then
		result = 3
	end
	
	return result
end


---------------------------------------------------------------------
-- BUTTONS
---------------------------------------------------------------------
-- Function to handle button events
local function handleBackButton( event )
	
    if ( "ended" == event.phase ) then
		composer.removeScene(scene)
		composer.gotoScene("mapScene")
	end
end

-- Function to handle button events
local function handleSaveButton( event )
	
    if ( "ended" == event.phase ) then
		-- get textbox text!
		selectionInfo = infoAdditional.text
		
		local success = saveCountryData(g_currentCountry, selectionRating, selectionData, selectionInfo)
		
		if success == true then
			createRegionMap(g_countries[g_currentCountry].region)
			
			openOverlay("Success")
		else
			openOverlay("Failure")
		end
	end
end

-- Function to handle select events
local function handleSelectButton( event )
	
    if ( "ended" == event.phase ) then
		local values = picker:getValues()
		
		if pickerSelection == 'Rating' then
			selectionRating = values[1].value
		else
			selectionData[pickerSelection] = getPickerValue(values[1].value)
		end
		
		infoButton[pickerSelection]:setLabel(values[1].value)
		
		infoAdditional.isVisible = true
		pickerStrip.isVisible = false
		
		pickerSelection = nil
		
		picker:removeSelf()
		picker = nil
		
		selectButton:removeSelf()
		selectButton = nil
	end
end

-- Function to handle button events
local function handleInfoButton( event )
	
	if ( "ended" == event.phase ) then
	
		if pickerSelection == nil then
			pickerSelection = event.target.id
			
			local columnData

			if pickerSelection == 'Rating' then
				columnData = 
				{ 
					{
						align = "center",
						labelPadding = 40,
						startIndex = selectionRating + 1,
						labels = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
					}
				}
			else
				columnData = 
				{ 
					{
						align = "center",
						labelPadding = 40,
						startIndex = selectionData[pickerSelection],
						labels = { g_countrySetting[1], g_countrySetting[2], g_countrySetting[3] }
					}
				}
			end

			picker = widget.newPickerWheel(
				{
					id = pickerSelection, 
					x = infoButton[pickerSelection].x,
					y = infoButton[pickerSelection].y,
					width = infoButton[pickerSelection].width, 
					height = g_contentHeight * 2, 
					rowHeight = 32, 
					fontSize = 18,
					style = "resizable", 
					columns = columnData
				}
			)
			
			infoAdditional.isVisible = false
			pickerStrip.isVisible = true
			
			selectButton = widget.newButton(
				{
					x = infoButton[pickerSelection].x + infoButton[pickerSelection].width, 
					y = infoButton[pickerSelection].y, 
					width = infoButton[pickerSelection].width, 
					height = 36, 
					shape = "rect", 
					fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } }, 
					strokeColor = { default={ 'black' }, over={ 'black' } }, 
					label = "Select", 
					font = native.systemFont, 
					fontSize = 16, 
					onEvent = handleSelectButton
				}
			)
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	
	background = display.newRect(
		display.contentCenterX,
		display.contentCenterY, 
		g_contentWidth, 
		g_contentHeight
	)
	
	background:setFillColor('black')
	sceneGroup:insert(background)
	
	centerText = display.newText({
		text = "", 
		x = display.contentCenterX, 
		y = g_iconSeparation[2], 
		font = native.systemFontBold, 
		fontSize = 20, 
		align = "center"
	})
	
	sceneGroup:insert(centerText)
	
	local y_pos = g_contentHeight / 5 + 10
	
	infoText['Rating'] = display.newText(
		{
			text = 'Rating',
			x = 0, 
			y = y_pos, 
			font = native.systemFont, 
			fontSize = 16,
			align = "left"
		}
	)
	
	infoText['Rating'].anchorX = 0
	sceneGroup:insert(infoText['Rating'])
	
	infoButton['Rating'] = widget.newButton(
		{
			x = display.contentCenterX - ( 0.1 * g_contentWidth ), 
			y = y_pos, 
			width = 75, 
			height = 30, 
			id = 'Rating', 
			shape = "roundedRect", 
			fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } }, 
			strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } }, 
			label = "Yes", 
			font = native.systemFont, 
			fontSize = 16, 
			onEvent = handleInfoButton
		}
	)
	
	sceneGroup:insert(infoButton['Rating'])
	
	local data
	-- iterate through each characteristic and create buttons and info labels
	for i = 1, MAX_CHARACTERISTICS, 1 do
		data = g_countryCharacteristics[i]
		
		if data.id ~= 'Rating' then
			y_pos = y_pos + separation
			infoText[data.id] = display.newText(
				{
					text = data.id,
					x = 0, 
					y = y_pos, 
					font = native.systemFont, 
					fontSize = 16,
					align = "left"
				}
			)
			
			infoText[data.id].anchorX = 0
			sceneGroup:insert(infoText[data.id])
			
			infoButton[data.id] = widget.newButton(
				{
					x = display.contentCenterX - ( 0.1 * g_contentWidth ), 
					y = y_pos, 
					width = 75, 
					height = 30, 
					id = data.id, 
					shape = "roundedRect", 
					fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } }, 
					strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } }, 
					label = "Yes", 
					font = native.systemFont, 
					fontSize = 16, 
					onEvent = handleInfoButton
				}
			)
			
			sceneGroup:insert(infoButton[data.id])
		end
	end
	
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
	backButton.x = g_contentWidth - g_iconSize - g_iconSeparation[1] - 20
	backButton.y = g_contentHeight - g_iconSeparation[2]
	
	sceneGroup:insert(backButton)
	
	-- save button
	local saveButton = widget.newButton(
		{
			width = g_iconSize,
			height = g_iconSize,
			defaultFile = "save-icon.png",
			overFile = "save-icon.png",
			onEvent = handleSaveButton
		}
	)

	-- place the button
	saveButton.x = g_contentWidth - ( 2 * ( g_iconSize + g_iconSeparation[1] ) ) - 20
	saveButton.y = g_contentHeight - g_iconSeparation[2]
	
	sceneGroup:insert(saveButton)
	
	pickerStrip = display.newRect(
		
		display.contentCenterX - ( 0.1 * g_contentWidth ), 
		display.contentCenterY, 
		infoButton['Rating'].width, 
		g_contentHeight * 2
	)
	
	pickerStrip:setFillColor(1,1,1,1)
	pickerStrip.isVisible = false
	
	sceneGroup:insert(pickerStrip)
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is still off screen (but is about to come on screen) --]]
		
		centerText.text = "Edit Details (" .. g_currentCountry .. ")"
		
		for key,value in pairs(infoButton) do
			if key == 'Rating' then
				infoButton[key]:setLabel(g_countries[g_currentCountry]['rating'])
			else
				infoButton[key]:setLabel(g_countrySetting[g_countries[g_currentCountry]['data'][key]])
			end
		end
		
		infoAdditional = native.newTextBox(
			display.contentCenterX + ( 0.25 * g_contentWidth ), 
			g_contentHeight / 5 + 10, 
			0.5 * g_contentWidth, 
			0.5 * g_contentHeight
		)
		
		infoAdditional.text = g_countries[g_currentCountry]['info']
		infoAdditional.isEditable = true
		infoAdditional.placeholder = 'Information here.'
		infoAdditional.size = 0
		infoAdditional.anchorY = 0
		
		-- setup selection as our temporary data structure for this scene
		selectionData = g_countries[g_currentCountry]['data']
		selectionRating = g_countries[g_currentCountry]['rating']
		selectionInfo = g_countries[g_currentCountry]['info']
		
    elseif ( phase == "did" ) then
        --[[ Code here runs when the scene is entirely on screen --]]
		
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is on screen (but is about to go off screen) --]]
		if infoAdditional and infoAdditional.removeSelf then
			infoAdditional:removeSelf()
			infoAdditional = nil
		end
		
		
    elseif ( phase == "did" ) then
        --[[ Code here runs immediately after the scene goes entirely off screen --]]
 
    end
end

function scene:destroy( event )
 
    local sceneGroup = self.view
    --[[ Code here runs prior to the removal of scene's view --]]
 
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