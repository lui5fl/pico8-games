-- drawIntro
function drawBird()
	spr(240-16*(flr(intro.frames/15)%2), intro.x, intro.y)
end

function drawWordmark()
	sspr(9, 120, 19, 5, intro.x + 9, intro.y, 19, 5)
end

-- drawStart
function drawLogo()
	sspr(56, 0, 20, 15, 44, 40 + start.logoY, 40, 30)
end

function drawSquares()
	for i = 1, menuPlayers do
		rectfill(16 * (i-1), start.floorY + 113, 16 * (i-1) + 7, start.floorY + 120, colors[i])
	end
end

function drawControls()
	print("⬅️ " .. menuPlayers .. " players ➡️ ", 35 - start.controlsX, 78, 5)
	print("❎/🅾️ to start", 36 + start.controlsX, 87, 5)
end

-- drawGame
function drawProjectiles()
	for i = 1, #projectiles do
		if projectiles[i].v then 
			rectfill(projectiles[i].x - 2, projectiles[i].y - 2, projectiles[i].x + 2, projectiles[i].y + 2, 2)
		end
	end
end

function drawPlatforms()
	for i = 1, #platforms[platform] do
		rectfill(platforms[platform][i][1], platforms[platform][i][2], platforms[platform][i][1]+platforms[platform][i][3], platforms[platform][i][2]+4, 5)
	end
end

function drawPlayers()
	for i = 1, #players do
		if players[i].v then rectfill(players[i].x, players[i].y, players[i].x + 7, players[i].y + 7, colors[i]) end
	end
end

function drawBottomBar()
	local best = getBestPlayer()
	if not(backToMenu.startAnimating) then
		for i = 1, #players do 
			if i != best then
				if players[i].v then rectfill(16*(i-1), 121-backToMenu.y, 16*(i-1)+15, 127-backToMenu.y, colors[i])
				else rectfill(16*(i-1), 121-backToMenu.y, 16*(i-1)+15, 127-backToMenu.y, 5) end
				print(players[i].p, 12+16*(i-1), 122-backToMenu.y, 7)
			end
		end
	end
	if players[best].v then rectfill(16*(best-1)-gameEnd.barScale, 121-gameEnd.barScale-backToMenu.y, 16*(best-1)+15+gameEnd.barScale, 127+gameEnd.barScale-backToMenu.y*3, colors[best])
	else rectfill(16*(best-1), 121-backToMenu.y, 16*(best-1)+15, 127-backToMenu.y*3, 5) end
	if not(backToMenu.startAnimating) then print(players[best].p, 12+16*(best-1), 122+gameEnd.barScale-backToMenu.y, 7) end
	drawTime()
end

function drawTime()
	local seconds = flr(time / 60)
	if seconds > 9 then print(seconds, 120, 122+gameEnd.barScale, 1)
	else print(seconds, 124, 122, 1) end
end

function drawWinnerText()
	local winner = getBestPlayer()
	if winner == 1 then print("Blue wins!", 44, 60+gameEnd.playerY-backToMenu.y, 7)
	elseif winner == 2 then print("Green wins!", 42, 60+gameEnd.playerY-backToMenu.y, 7)
	elseif winner == 3 then print("Orange wins!", 40, 60+gameEnd.playerY-backToMenu.y, 7)
	elseif winner == 4 then print("Red wins!", 46, 60+gameEnd.playerY-backToMenu.y, 7) end
end