function animateStart()
	if start.frames > 59 then
		if start.logoY > 0.05 then start.logoY -= 0.5 * start.logoY/8 end
		if start.floorY > 0.05 then start.floorY -= 1 * start.floorY/16
		else start.finishedAnimating = true end
		if start.controlsX > 0.05 then start.controlsX -= 1.2 * start.controlsX/16 end
	end
end