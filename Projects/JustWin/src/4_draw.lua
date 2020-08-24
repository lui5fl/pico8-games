function _draw()
	cls(6)

	-- Floor
	rectfill(0, start.floorY + 121, 128, start.floorY + 128, 7)
	if mode == "intro" then cls(0) drawIntro()
	elseif mode == "start" then drawStart()
	else drawGame() end
end

function drawIntro()
	drawBird()
	drawWordmark()
end

function drawStart()
	drawLogo()
	drawSquares()
	drawControls()
	animateStart()
	if gameEnd.finishedAnimating then
		drawBottomBar()
		drawWinnerText()
		if backToMenu.startAnimating then
			animateBackToMenu()
		end
	end
end

function drawGame()
	drawProjectiles()
	drawPlatforms()
	drawPlayers()
	drawBottomBar()
	if mode == "end" then
		drawWinnerText() 
		animateEnd()
	end
end