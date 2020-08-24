
-- DesertBus
-- by luisfl.me
-- Compiled: 24/08/20 12:45:05

-- 1_init.lua

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

-- 2_update.lua

function _update60()
	if mode == "intro" then updateIntro()
	elseif mode == "start" then updateStart()
	else updateGame() end
end

function updateIntro()
	if intro.frames < 59 then intro.frames += 1
	else intro.frames = 0 -- mode = "start"
		mode = "game"
	end
end

function updateStart()
	-- TODO
end

function updateGame()

	-- Road
	if btn(0) then roadPointX += 0.5
	else roadPointX -= 0.0625 end
	roadLine += 1
	if roadLine > 31 then roadLine = 0 end
	roadDebrisFrames += 1
	if roadDebrisFrames > 59 then roadDebrisFrames = 0 end

	-- Bus
	if busBounce > 2.05 then busBounceNext = -0.1
	elseif busBounce < -2.05 then busBounceNext = 0.1 end
	busBounce += busBounceNext

end

-- 3_updateFunctions.lua

-- updateStart

function updateStartMenu()
	-- TODO
end

-- updateGame

-- 4_draw.lua

function _draw()
	cls(9)
	if mode == "intro" then cls(0) drawIntro()
	elseif mode == "start" then drawStart()
	else drawGame() end
end

function drawIntro()
	drawBird()
	drawWordmark()
end

function drawStart()
	-- TODO
end

function drawGame()

	local max = 5

	-- Debris
	-- drawDebris()

	-- Road
	for y = 0, 93 do
		-- Brown
		line(roadPointX-y*1.6, y+35, roadPointX+y*1.6, y+35, 4)
		-- Gray
		line(roadPointX-y*1.2, y+35, roadPointX+y*1.2, y+35, 5)
	end

	-- Yellow lines
	for x = -1, 1 do line(roadPointX, roadPointY, ((roadPointX*2-128)+(roadPointX*max-128))/2 + x, 128, 10) end
	for y = 0 + roadLine, 93, 29 do
		for y2 = -4, 4 do
			line(roadPointX + roadPointX*(y/93)-128*(y/93)+60*(y/93), y+35+y2, roadPointX + roadPointX*(max-1)*(y/93)-128*(y/93)-60*(y/93), y+35+y2, 5)
		end
	end

	-- Sky
	rectfill(0, 0, 128, 35, 12)
	rectfill(0, 35, 128, 35, 6)

	-- Upper part of bus
	sspr(0, 0, 128, 32, 0, 0+busBounce, 128, 32)
	rectfill(0, -8+busBounce, 128, -1+busBounce, 5)

	-- Bottom part of bus
	sspr(0, 32, 128, 32, 0, 96+busBounce, 128, 32)
	rectfill(0, 128+busBounce, 128, 135+busBounce, 0)

end

function drawDebris()
	if roadDebrisFrames % 10 == 0 then
		roadDebris = {}
		for x = 0, 127 do
			for y = 35, 92 do
				if rnd(10) < 0.025 then add(roadDebris, {x, y}) end
			end
		end
	end
	for dot in all(roadDebris) do
		rectfill(dot[1], dot[2], dot[1], dot[2], 4)
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

-- 6_animate.lua

function animateStart()
	if start.frames > 59 then
		if start.logoY > 0.05 then start.logoY -= 0.5 * start.logoY/8 end
		if start.floorY > 0.05 then start.floorY -= 1 * start.floorY/16
		else start.finishedAnimating = true end
		if start.controlsX > 0.05 then start.controlsX -= 1.2 * start.controlsX/16 end
	end
end
