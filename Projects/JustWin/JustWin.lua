
-- JustWin
-- by luisfl.me
-- Compiled: 24/08/20 13:02:34

-- 1_init.lua

function _init()
	sfx(0)
	mode = "intro"
	initGlobal()
end

function initGlobal()
	initIntro()
	initStart()
	initEnd()

	menuPlayers = 4
	platforms = { 
		{ { 0, 16, 16 }, { 113, 16, 16 }, { 48, 32, 32 }, { 16, 64, 16 }, { 96, 64, 16 }, { 32, 96, 64 } },
		{ { 20, 32, 24 }, { 84, 32, 24 }, { 16, 64, 16 }, { 96, 64, 16 }, { 48, 80, 32 }, { 32, 96, 64 } }
	}
	players = {}
	colors = { 1, 3, 9, 8 }
end

function initIntro()
	intro = {}
	intro.x = 48
	intro.y = 61
	intro.frames = 0
end

function initStart()
	start = {}
	start.logoY = 8
	start.floorY = 16
	start.controlsX = 200
	start.frames = 0
	start.sound = true
	start.finishedAnimating = false
end

function initEnd()
	gameEnd = {}
	gameEnd.barScale = 0
	gameEnd.playerY = 150
	gameEnd.barY = 0
	gameEnd.finishedAnimating = false
	backToMenu = {}
	backToMenu.startAnimating = false
	backToMenu.finishedAnimating = false
	backToMenu.sound = true
	backToMenu.frames = 0
	backToMenu.y = 0
end

function startGame()
	initPlayers(false)
	initPlayersPoints()
	initGame()
end

function initGame()
	mode = "game"
	sfx(4)
	frames = 0
	time = 3659
	projectiles = {}
	platform = flr(rnd(2)+1)
	initPlayers(true)
end

function initPlayers(withPoints)
	if withPoints then
		for i = 1, menuPlayers do createPlayer(i, 16 * (i-1), players[i].p) end
	else
		for i = 1, menuPlayers do createPlayer(i, 16 * (i-1), 0) end
	end
end

-- 2_update.lua

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

-- 3_updateFunctions.lua

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

-- 4_draw.lua

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

-- 5_drawFunctions.lua

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

-- 6_creators.lua

function createPlayer(id, x, points)
	local p = {}

	-- Position
	p.x = x
	p.y = 113

	-- Movement
	p.dx = 0
	p.dy = 0

	-- Direction
	p.d = 1

	-- Sounds
	p.sounds = {}
	p.sounds.jump = true
	p.sounds.floor = false

	-- Jump Variables
	p.j = 2
	p.f = false
	p.jumpFrames = -1
	p.enableJumpFrames = false

	-- Rounds Won
	p.p = points

	-- Visible
	p.v = true

	players[id] = p
end

function initPlayersPoints()
	for i = 1, #players do
		players[i].p = 0
	end
end

function createProjectile(player, direction)
	local p = {}
	p.p = player
	p.x = players[player].x + 4
	p.y = players[player].y + 4
	p.d = direction
	p.v = true
	add(projectiles, p)
end

-- 7_animate.lua

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

-- 8_functions.lua

function closestPlatform(player)
	local y = 113
	for i = 1, #platforms[platform] do
		if platforms[platform][i][1] < players[player].x + 8 and platforms[platform][i][1] + platforms[platform][i][3] > players[player].x and
		platforms[platform][i][2] > players[player].y + 4 then
			if y > platforms[platform][i][2] - 8 then y = platforms[platform][i][2] - 8 end
		end
	end
	return y
end

function getBestPlayer()
	local best = 1
	for i = 2, #players do if players[best].p < players[i].p then best = i end end
	return best
end
