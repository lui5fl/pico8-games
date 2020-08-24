-- updateStart

function updateStartMenu()
	if start.finishedAnimating and (not(backToMenu.startAnimating) or backToMenu.finishedAnimating) then
		if btnp(4, 0) or btnp(5, 0) then startGame()
		elseif btnp(0, 0) then selectStartOption(-1)
		elseif btnp(1, 0) then selectStartOption(1) end
	end
end

function selectStartOption(num)
	menuPlayers += num
	if menuPlayers < 2 then menuPlayers = 2 sfx(6)
	elseif menuPlayers > 4 then menuPlayers = 4 sfx(6)
	else sfx(7) end
end

-- updateGame
function updatePlayers()
	for i = 1, #players do
		if players[i].v and time < 3630 then
			updatePlayerMovement(i)
			updatePlayerJump(i)
		end
	end
end

function updatePlayerMovement(i)
	for j = 0, 5 do
		if j != 4 then
			if btn(j, i-1) and j != 5 then
				if j < 2 then players[i].dx = 4*j-2 end
				players[i].d = j
				if btnp(5, i-1) and time < 3600 then
					sfx(7+i)
					createProjectile(i, j)
					break
				end
			elseif btnp(5, i-1) and time < 3600 then
				sfx(7+i)
				createProjectile(i, players[i].d)
				break
			end
		end
	end
end

function updatePlayerJump(i)
	if not(players[i].f) then
		if btn(4, i-1) or players[i].jumpFrames > -1 then
			players[i].sounds.floor = true
			players[i].enableJumpFrames = true
			if players[i].enableJumpFrames then players[i].jumpFrames += 1 end
			if players[i].jumpFrames > 14 then players[i].enableJumpFrames = false players[i].jumpFrames = -1 end
			if players[i].sounds.jump then sfx(3) players[i].sounds.jump = false end
			players[i].dy = -players[i].j
			if players[i].j >= 0.5 then players[i].j -= 0.05
			else players[i].f = true end
		else
			players[i].j = 0.25
			players[i].f = true
		end
	end

	if players[i].y == 0 then players[i].enableJumpFrames = false players[i].jumpFrames = -1 players[i].f = true end

	if players[i].f then
		players[i].dy = players[i].j
		if players[i].j <= 3 then players[i].j += 0.1*players[i].j end
	end

	players[i].x += players[i].dx
	players[i].y += players[i].dy
	if players[i].dx > 0.1 then players[i].dx -= 0.25
	elseif players[i].dx < -0.1 then players[i].dx += 0.25 end

	players[i].x = mid(0, players[i].x, 120)
	players[i].y = mid(0, players[i].y, 113)

	if players[i].f then
		closest = closestPlatform(i)
		if players[i].y >= closest then 
			if players[i].sounds.floor then sfx(6) players[i].sounds.floor = false end
			players[i].sounds.jump = true
			players[i].y = closest 
			players[i].f = false 
			players[i].j = 2
		end
	end
end

function updateProjectiles()
	for i = 1, #projectiles do
		if projectiles[i].d == 0 then projectiles[i].x -= 2.5 + players[projectiles[i].p].j
		elseif projectiles[i].d == 1 then projectiles[i].x += 2.5 + players[projectiles[i].p].j
		elseif projectiles[i].d == 2 then projectiles[i].y -= 2.5 + players[projectiles[i].p].j
		elseif projectiles[i].d == 3 then projectiles[i].y += 2.5 + players[projectiles[i].p].j end
	end
end

function checkProjectiles()
	for i = 1, #players do
		for j = 1, #projectiles do
			for k = 1, #platforms[platform] do
				if projectiles[j].x > platforms[platform][k][1] and projectiles[j].x < platforms[platform][k][1] + platforms[platform][k][3] and
				projectiles[j].y > platforms[platform][k][2] and projectiles[j].y < platforms[platform][k][2] + 4 then
					projectiles[j].v = false
				end
			end
			if projectiles[j].p != i then
				if projectiles[j].x > players[i].x - 2 and projectiles[j].x < players[i].x + 10 and
				projectiles[j].y > players[i].y - 2 and projectiles[j].y < players[i].y + 10 and
				projectiles[j].v and players[i].v then 
					projectiles[j].v = false
					defeatPlayer(i, projectiles[j].p)
				end
			end
		end
	end
end

-- updateEnd
function updateBackToMenu()
	for i = 1, #players do
		if (btnp(4, i-1) or btnp(5, i-1)) and backToMenu.frames > 90 then
			if backToMenu.sound then sfx(17) backToMenu.sound = false end
			mode = "start"
			backToMenu.startAnimating = true
		end
	end
end

-- Round Progress
function defeatPlayer(idDefeated, id)
	players[idDefeated].v = false
	local playersLeft = 0
	for i = 1, #players do if players[i].v then playersLeft += 1 end end
	if playersLeft == 1 then winRound(id) else sfx(11+idDefeated) end
end

function winRound(id)
	mode = "roundEnd" players[id].p += 1
	if not(gameWon()) then sfx(2) end
end

function gameWon()
	local best = getBestPlayer()
	if players[best].p >= 10 then sfx(16) mode = "end" return true end
	return false
end