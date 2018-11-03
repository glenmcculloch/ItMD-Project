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

local separation = 40

local region = 'Africa'
local country = 'Kenya'

---------------------------------------------------------------------
-- BACK BUTTON
---------------------------------------------------------------------
-- Function to handle button events
local function handleBackButton( event )
	
    if ( "ended" == event.phase ) then
        print("Back button was pressed!")
		
		composer.removeScene(scene)
		composer.gotoScene("mapScene")
	end
end
-- Function to handle button events
local function handleSaveButton( event )
	
    if ( "ended" == event.phase ) then
        print("Save button was pressed!")
		
		-- SAVE TO FILE
	end
end

-- Function to handle button events
local function handleInfoButton( event )
	
	if ( "ended" == event.phase ) then
		local selected = event.target.id
        print(selected.." button was pressed!")
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
	
	background:setFillColor( 0.5 )
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
	
	infoAdditional = native.newTextBox(
		display.contentCenterX + ( 0.25 * g_contentWidth ), 
		y_pos, 
		0.5 * g_contentWidth, 
		0.5 * g_contentHeight
	)
	
	infoAdditional.isEditable = true
	infoAdditional.placeholder = 'Information here.'
	infoAdditional.size = 0
	infoAdditional.anchorY = 0
	
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
	
	-- iterate through each characteristic and create buttons and info labels
	for key,value in pairs(g_countryCharacteristic) do
		if key ~= 'Additional Information' and key ~= 'Rating' then
			y_pos = y_pos + separation
			infoText[key] = display.newText(
				{
					text = key,
					x = 0, 
					y = y_pos, 
					font = native.systemFont, 
					fontSize = 16,
					align = "left"
				}
			)
			
			infoText[key].anchorX = 0
			sceneGroup:insert(infoText[key])
			
			infoButton[key] = widget.newButton(
				{
					x = display.contentCenterX - ( 0.1 * g_contentWidth ), 
					y = y_pos, 
					width = 75, 
					height = 30, 
					id = key, 
					shape = "roundedRect", 
					fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } }, 
					strokeColor = { default={ 0, 0, 0 }, over={ 0.4, 0.1, 0.2 } }, 
					label = "Yes", 
					font = native.systemFont, 
					fontSize = 16, 
					onEvent = handleInfoButton
				}
			)
			
			sceneGroup:insert(infoButton[key])
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
	
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is still off screen (but is about to come on screen) --]]
		
		centerText.text = "Edit Details (" .. country .. ")"
		infoAdditional.text = g_countries[region][country]['Additional Information']
		
		for key,value in pairs(infoButton) do
			if key == 'Rating' then
				infoButton[key]:setLabel(g_countries[region][country][key])
			else
				infoButton[key]:setLabel(g_countrySetting[g_countries[region][country][key]])
			end
		end
		
		
    elseif ( phase == "did" ) then
        --[[ Code here runs when the scene is entirely on screen --]]
		
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        --[[ Code here runs when the scene is on screen (but is about to go off screen) --]]
		
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