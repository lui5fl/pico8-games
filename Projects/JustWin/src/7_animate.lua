function animateStart()
	if start.frames > 59 then
		if start.logoY > 0.05 then start.logoY -= 0.5 * start.logoY/8 end
		if start.floorY > 0.05 then start.floorY -= 1 * start.floorY/16
		else start.finishedAnimating = true end
		if start.controlsX > 0.05 then start.controlsX -= 1.2 * start.controlsX/16 end
	end
end

function animateEnd()
	if gameEnd.barScale < 150 then gameEnd.barScale += 3 * (gameEnd.barScale+1)/25 end
	if gameEnd.playerY > 0.05 and gameEnd.barScale > 50 then gameEnd.playerY -= 2 * gameEnd.playerY/30
	else gameEnd.finishedAnimating = true end
end

function animateBackToMenu()
	if backToMenu.y < 300 then backToMenu.y += 3 * (backToMenu.y+1)/50
	else initEnd() end
	if gameEnd.barScale > 130 then gameEnd.barScale -= 1 * (gameEnd.barScale+1)/50 end
end