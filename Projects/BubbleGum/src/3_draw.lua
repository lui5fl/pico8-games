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