
-- BubbleGum
-- by luisfl.me
-- Compiled: 24/08/20 12:59:46

-- 1_init.lua

function _init()
	mode = "game"

	-- Player
	p = {}
	p.x = 16
	p.y = 112
	p.dx = 0
	p.dy = 0
	p.s = 2
	p.f = 0
	p.a = -1
	p.d = 0
	p.j = false

	-- Map
	m = {}
	m.x = -128
	m.y = 0
	m.px = 0
	m.a_l = false
	m.a_r = false
end

-- 2_update.lua

function _update60()
	if mode != "end" then updateGame() end
end

-- updateGame
function updateGame()
	if not(m.a_l) and not(m.a_r) then
		updatePlayer()
	end
end

function updatePlayer()
	updateMovement()
	updateSprite()
	updateMap()
end

function updateMovement()
	-- Jump
	if (btnp(4) or btnp(5)) and not(p.j) then 
		p.j = true
		if btnp(0) then p.dx = -0.25
		elseif btnp(1) then p.dx = 0.25 end
	end

	if p.j then p.f += 1 p.dy = (p.f - 30)/30 end

	-- Movement
	if btn(0) and p.j then p.dx -= 0.025
	elseif btn(1) and p.j then p.dx += 0.025 end

	local nextX = p.x + p.dx
	local nextY = p.y + p.dy

	if not(tileAside(nextX)) then p.x = nextX end
	if not(floorBelow(nextY)) then p.y = nextY
	else 
		if p.a < 0 and p.j then p.a = 0 end 
		p.y = (cy-1)*8 p.dx = 0 p.j = false p.f = 0 
	end
end

function tileAside(nextX)
	local cx = flr((abs(m.x)/128)*16+flr((nextX-0.5)/8))
	local cy = flr((abs(m.y)/128)*16+flr(p.y/8))
	if fget(mget(cx, cy), 0) or fget(mget(cx+1, cy), 0) then
		return true
	end return false
end

function floorBelow(nextY)
	local cx = flr((abs(m.x)/128)*16+flr(p.x/8))
	cy = flr((abs(m.y)/128)*16+flr((nextY+7)/8))
	if fget(mget(cx, cy), 0) or fget(mget(cx+1, cy), 0) then 
		return true 
	end return false
end

function updateSprite()
	-- Jumping
	if not(p.j) then p.s = 2
	else
		if p.dx < 0 then p.s = 10
		elseif p.dx > 0 then p.s = 11
		else p.s = 9 end
	end

	-- After jump
	if p.a > 14 then p.a = -1 end
	if p.a > -1 then 
		if p.a > 2 then p.s = 3 end 
		p.a += 1 
	end
end

function updateMap()
	if p.x < -4 then m.a_l = true m.px = m.x + 128
	elseif p.x > 124 then m.a_r = true m.px = m.x - 128
	end
end

-- 3_draw.lua

function _draw()
	cls(1)
	palt(8, true) palt(0, false)
	map(0, 0, m.x, m.y, 48, 16)
	drawTitleScreen()
	animateMap()
	spr(p.s, p.x, p.y)
end

function drawTitleScreen()
	print("❎/🅾️ jump", m.x + 128 + 16, 88, 1)
	print("move ⬅️/➡️", m.x + 128 + 73, 88, 1)
	sspr(0, 32, 48, 32, m.x + 128 + 16, 16, 96, 64)
end

function animateMap()
	local x = abs(m.px - m.x)
	if m.a_l then
		if x > 1 then m.x += 4*(x/32) p.x += 4*(x/32)
		else m.a_l = false m.x += x p.x += x end
	elseif m.a_r then
		if x > 1 then m.x -= 4*(x/32) p.x -= 4*(x/32)
		else m.a_r = false m.x -= x p.x -= x end
	end
end
