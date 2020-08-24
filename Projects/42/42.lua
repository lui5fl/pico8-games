
-- 42
-- by luisfl.me

function _init()
	cls()
	music(0)
	mode = "start"

	-- player
	p = {} p.x = 56 p.y = 108 p.spr = 0 p.dx = 0 p.s = 1

	-- walls
	w = {} w.x = {} w.y = {} w.t = 42 w.inv = {}

	-- background
	bg = true
	l = {} l.x = {} l.y = {} l.h = {} l.c = {} l.s = {}
	c = {} c.x = {} c.y = {} c.c = {} c.s = {}
	if bg then init_background() end

	-- menu
	m = {}
	m.x = {51, 57, 61}
	m.y = 87
	m.arrow_y = {87, 87}
	m.frames = {0, 0}
	m.count = {false, false}
	m.option = 1
	m.enabled = true
	m.text = {"classic", "easy", "bg"}
	m.text_x = m.x[1] + 1

	-- misc
	num = 0 lost = false
	sound2 = true sound3 = true sound16 = true
	sounds = {sound2, sound3, sound16}
	count = false frames = 0 difficulty = 1.82
end

function mode_start() mode = "start" end
function mode_game() mode = "game" end
function mode_end() mode = "end" end

function _update60()
	if mode == "start" then update_start()
	else update_game() end
end

function update_start()
	if bg then update_background() end
	if btnp(5) and m.enabled then
		if m.option == 2 then difficulty = 0.75 end
		if m.option == 3 then sfx(4) bg = not(bg)
		else m.count[1] = true m.enabled = false sfx(16) music(-1, 900) count = true
		end 
	elseif btnp(4) and m.enabled then sfx(4) m.option += 1 m.count[2] = true end
	if m.option < 1 then m.option = 3 elseif m.option > 3 then m.option = 1 end
	for i = 1, 2 do
		if m.frames[i] > 0 then m.arrow_y[i] = 88
		else m.arrow_y[i] = 87 end
		if m.count[i] then m.frames[i] += 1 end
		if m.frames[i] > 10 then m.count[i] = false m.frames[i] = 0 end
	end
	if count then frames += 1 end
	if frames > 120 then mode = "game" if m.option == 2 then music(32) else music(4) end frames = 0 end
end

function update_game()
	if not(lost) and num != w.t then p_mov() walls() checkcollision() if bg then update_background() end end
	if lost then p.spr = 16 if sound2 then sfx(2) sound2 = false end
		frames += 1
		prevoption = m.option
		prevbg = bg
		if frames > 30 then
			if btnp(5) then
				_init() mode = "game" m.option = prevoption bg = prevbg if m.option == 2 then music(32) difficulty = 0.75 else music(4) end frames = 0
			elseif btnp(4) then _init() frames = 0 bg = prevbg end
		end
	end
	if num == w.t and sound3 then music(-1) p.spr = 32 sfx(3) sound3 = false end
end

function _draw()
	if mode == "start" then draw_start()
	elseif mode == "game" and not(lost) then draw_game()
	else draw_end() end
	if mode == "game" then sspr(p.spr, 0, 16, 16, p.x, p.y) end
end

function draw_start()
	cls()
	if bg then draw_background() end
	sspr(80, 0, 32, 16, 51, 32)
	rectfill(46, m.y+2, 82, m.y+6, 6)
	rectfill(47, m.y, 81, m.y+8, 6)
	rectfill(46, m.y+1, 82, m.y+5, 7)
	rectfill(47, m.y-1, 81, m.y+7, 7)
	print(m.text[m.option], m.x[m.option], m.y+1, 1)
	rectfill(33, 89, 43, 93, 6)
	rectfill(34, 87, 42, 95, 6)
	rectfill(33, m.arrow_y[1]+1, 43, m.arrow_y[1]+5, 7)
	rectfill(34, m.arrow_y[1]-1, 42, m.arrow_y[1]+7, 7)
	sspr(0, 16, 7, 3, 35, m.arrow_y[1]+2)
	rectfill(85, 89, 95, 93, 6)
	rectfill(86, 87, 94, 95, 6)
	rectfill(85, m.arrow_y[2]+1, 95, m.arrow_y[2]+5, 7)
	rectfill(86, m.arrow_y[2]-1, 94, m.arrow_y[2]+7, 7)
	sspr(0, 19, 3, 5, 89, m.arrow_y[2]+1)
end

function draw_game()
	cls()
	if bg and num != w.t then draw_background() end
	for i = 1, w.t do
		if w.x[i] == 0 then
			-- line(32, w.y[i], 128, w.y[i], 12)
			line(32, w.y[i], 128, w.y[i], 7)
			line(32, w.y[i]-1, 128, w.y[i]-1, 7)
			line(32, w.y[i]-2, 128, w.y[i]-2, 7)
			line(32, w.y[i]+1, 128, w.y[i]+1, 9)
		elseif w.x[i] == 1 then 
			-- line(0, w.y[i], 32, w.y[i], 12)
			-- line(64, w.y[i], 128, w.y[i], 12)
			line(0, w.y[i], 32, w.y[i], 7)
			line(64, w.y[i], 128, w.y[i], 7)
			line(0, w.y[i]-1, 32, w.y[i]-1, 7)
			line(64, w.y[i]-1, 128, w.y[i]-1, 7)
			line(0, w.y[i]-2, 32, w.y[i]-2, 7)
			line(64, w.y[i]-2, 128, w.y[i]-2, 7)
			line(0, w.y[i]+1, 32, w.y[i]+1, 8)
			line(64, w.y[i]+1, 128, w.y[i]+1, 8)
		elseif w.x[i] == 2 then 
			-- line(0, w.y[i], 64, w.y[i], 12)
			-- line(96, w.y[i], 128, w.y[i], 12)
			line(0, w.y[i], 64, w.y[i], 7)
			line(96, w.y[i], 128, w.y[i], 7)
			line(0, w.y[i]-1, 64, w.y[i]-1, 7)
			line(96, w.y[i]-1, 128, w.y[i]-1, 7)
			line(0, w.y[i]-2, 64, w.y[i]-2, 7)
			line(96, w.y[i]-2, 128, w.y[i]-2, 7)
			line(0, w.y[i]+1, 64, w.y[i]+1, 11)
			line(96, w.y[i]+1, 128, w.y[i]+1, 11)
		elseif w.x[i] == 3 then 
			-- line(0, w.y[i], 96, w.y[i], 12)
			line(0, w.y[i], 96, w.y[i], 7)
			line(0, w.y[i]-1, 96, w.y[i]-1, 7)
			line(0, w.y[i]-2, 96, w.y[i]-2, 7)
			line(0, w.y[i]+1, 96, w.y[i]+1, 12)
		end
	end
	if num == w.t then 
		print("you did it! :d", 36, 41, 5)
		print("you did it! :d", 36, 40, 7)
	end
	if num < w.t then
		circfill(14, 5, 4, 6) 
		circfill(14, 4, 4, 7)
		rectfill(0, 0, 15, 9, 6)
		rectfill(0, 0, 15, 8, 7)
		print(num, 4, 2, 1)
	end
end

function draw_end()
	cls()
	print("you lost :(", 42, 61, 5)
	print("you lost :(", 42, 60, 7)
end

function init_background()
	init_lines()
	init_dots()
end

function init_lines()
	for i = 0, 128, 1 do
		add(l.x, i)
		add(l.y, flr(rnd(128)))
		add(l.h, flr(rnd(6)+6))
		add(l.c, flr(rnd(2)+5))
		add(l.s, flr(rnd(2)+2))
	end
end

function init_dots()
	for i = 4, 124, 2 do
		add(c.x, i)
		add(c.y, flr(rnd(128)))
		add(c.c, flr(rnd(2)+5))
		add(c.s, flr(rnd(2)+2))
	end
end

function update_background()
	update_lines()
	update_dots()
end

function update_lines()
	for i = 1, #l.x do l.y[i] -= l.s[i] end
	for i = 1, #l.x do if l.y[i]+l.h[i] == 0 then l.y[i] = 128 end end
end

function update_dots()
	for i = 1, #c.x do c.y[i] -= c.s[i] end
	for i = 1, #c.x do if c.y[i] == 0 then c.y[i] = 128 end end
end

function draw_background()
	draw_lines()
	draw_dots()
end

function draw_lines()
	for i = 1, #l.x do
		line(l.x[i], l.y[i], l.x[i], l.y[i]+l.h[i], l.c[i])
	end
end

function draw_dots()
	for i = 1, #c.x do
		circfill(c.x[i], c.y[i], 1, c.c[i])
	end
end

function p_mov()
	local press = false
	if btn(5) and btn(4) then else
		if btn(5) then p.dx = -2 - num/(w.t/(difficulty*2)) press = true end
		if btn(4) then p.dx = 2 + num/(w.t/(difficulty*2)) press = true end
	end
	if not(press) then p.dx = p.dx/2 end
	p.x += p.dx * p.s
	p.x = mid(4, p.x, 108)
end

function walls()
	local x local y local add_y = 0
	for i = 1, w.t do
		x = flr(rnd(4)) y = 0 - add_y
		while x == w.x[i-1] do x = flr(rnd(4)) end
		add_y += 64
		add(w.x, x) add(w.y, y)
	end
	for i = 1, w.t do if w.y[i] > 128 and not(contains(w.inv, i)) then 
		if num != w.t - 1 then sfx(1) end num += 1 add(w.inv, i) end 
	end
	for i = 1, w.t do w.y[i] += 1 + num/(w.t/difficulty) end
end

function checkcollision()
	for i = 1, w.t do
		if  (collision(p.x+1, p.y+1, 14, 14, 32, w.y[i], 96, 1) and w.x[i] == 0) or
			((collision(p.x+1, p.y+1, 14, 14, 0, w.y[i], 32, 1) or
			collision(p.x+1, p.y+1, 14, 14, 64, w.y[i], 64, 1)) and w.x[i] == 1) or
			((collision(p.x+1, p.y+1, 14, 14, 0, w.y[i], 64, 1) or
			collision(p.x+1, p.y+1, 14, 14, 96, w.y[i], 32, 1)) and w.x[i] == 2) or
			(collision(p.x+1, p.y+1, 14, 14, 0, w.y[i], 96, 1) and w.x[i] == 3)
			then lost = true music(-1) end
	end
end

function collision(x, y, w, h, wx, wy, ww, wh)
	if y > wy + wh then return false end
	if y + h < wy then return false end
	if x > wx + ww then return false end
	if x + w < wx then return false end
	return true
end

function sound_reset()
	for i = 1, #sounds do
		sounds[i] = true
	end
end

function contains(array, value)
	for i = 1, #array do
		if array[i] == value then return true end
	end return false
end
