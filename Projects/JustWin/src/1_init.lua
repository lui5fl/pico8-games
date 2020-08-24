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