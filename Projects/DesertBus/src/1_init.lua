function _init()
	palt(14, true) palt(0, false)
	sfx(0)
	mode = "intro"
	initGlobal()
end

function initGlobal()
	initIntro()
	initGame()
end

function initIntro()
	intro = {}
	intro.x = 48
	intro.y = 61
	intro.frames = 0
end

function initGame()

	-- Road
	roadPointX = 55
	roadPointY = 35
	roadLine = 0
	roadDebris = {}
	roadDebrisFrames = 0

	-- Bus
	busBounce = 0
	busBounceNext = 0.25

end