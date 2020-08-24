function _update60()
	if mode == "intro" then updateIntro()
	elseif mode == "start" then updateStart()
	elseif mode == "game" then updateGame()
	elseif mode == "roundEnd" then updateRoundEnd()
	elseif mode == "end" then updateEnd() end
end

-- updateIntro()
function updateIntro()
	if intro.frames < 59 then intro.frames += 1
	else intro.frames = 0 mode = "start" end
end

function updateStart()
	if start.frames < 180 then start.frames += 1 end
	if start.sound then sfx(1) start.sound = false end
	updateStartMenu()
end

function updateGame()
	time -= 1
	if time < 60 then time = 0 mode = "roundEnd" sfx(5) end
	updatePlayers()
	updateProjectiles()
	checkProjectiles()
end

function updateRoundEnd()
	frames += 1 
	if btnp() and frames > 60 then initGame() end 
end

function updateEnd()
	if backToMenu.frames < 100 then backToMenu.frames += 1 end
	updateBackToMenu()
end