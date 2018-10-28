-----------------------------------------------------------------------------------------
--
-- Dynamic map scene
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local screenGroup = self.view
	
	local webView = native.newWebView( display.contentCenterX, display.contentCenterY, content_width - 100, content_height - 100 )
    webView:request( "Asia-map.html", system.DocumentsDirectory )
	
	webView:addEventListener( "urlRequest", webViewListener )
end

-- Function to listen to the webview and register any clicks on the map
function webViewListener(event)
	-- a country was clicked
	if event.url and event.type == "other" then
		local country = string.gsub(event.url, "%%20", " ")
		country = split(country, ":")
		
		print(country[2])
		
		local options = {
			isModal = true, 
			effect = "fade", 
			time = 400, 
			params = {
				country_data = countries['Asia'][country[2]]
			}
		}
		
		composer.showOverlay( "countryOverlay", options )
	end
end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
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







