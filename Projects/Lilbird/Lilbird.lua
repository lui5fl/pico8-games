
-- Lilbird
-- by luisfl.me

function _init()
	cls()
	b = false -- button press
	f = 0 -- frames
	wf = 0 -- wall frames
	gf = 0 -- global frames
	s = 1 -- sprite
	sf = false -- sprite flag
	j = true -- jump flag
	fx = true -- sfx flag
	x = 60 y = 104 dx = 0 dy = 0 -- movement
	cx = 0 cy = 0 -- coin position
	md = 1 -- faster movement
	time = 30 + 1 -- time
	score = 0 -- score
	tcol = 1 -- time color
	tsnd = 8 -- time sound
	sfx(10)
end

function _update60()
	-- global frames update
	gf += 1

	-- coin update
	if time <= 6 then tsnd = 9 end
	if gf % 60 == 0 and gf >= 120 and time > 0 then time -= 1 sfx(tsnd) end
	if gf == 120 then cx = rnd(112)+8 cy = rnd(32)+70 end
	if gf == 1920 then sfx(7) cx = 0 cy = 0 end

	-- left & right
	if btn(0) then -- left
		f += 1 s = 3 sf = false
		if f % 15 == 0 and y == 104 and x >= 2 then sfx(2) end -- swimming sound
		if y == 104 and x >= 2 then -- sprite animation
			if f < 15 then s = 3 end if f >= 15 and f < 30 then s = 4 end
			if f >= 30 and f < 45 then s = 3 end if f >= 45 then s = 4 end
		end
		dx = -1 b = true
	elseif btn(1) then -- right
		f += 1 s = 1 sf = true
		if f % 15 == 0 and y == 104 and x <= 118 then sfx(2) end
		if y == 104 and x <= 118 then
			if f < 15 then s = 1 end if f >= 15 and f < 30 then s = 2 end
			if f >= 30 and f < 45 then s = 1 end if f >= 45 then s = 2 end
		end
		dx = 1 b = true
	else b = false end -- still

	-- jump
	if btnp(4) and j then
		sfx(1)
		j = false
		dy = -2.9
	end

	-- faster movement
	if btnp(5) then if fx == true then sfx(6) end fx = false end
	if btn(5) then md = 2 else md = 1 fx = true end

	-- still
	if not b then 
		if sf == false then s = 3 else s = 1 end
		dx = 0 f = 0 
	end

	-- one second max
	if f == 60 then f = 0 end

	-- jump
	if y < 76 and j then dy = -0.3 end 
	if y < 68 then dy = 2.1 end
	if y > 104 then y = 104 sfx(4) dy = 0 j = true end

	-- walls
	if (x == 0 or x == 120) and wf == 0 then sfx(5) wf = 1 end
	if x == 2 or x == 118 then wf = 0 end

	-- update position
	x += md*dx y += dy
	x = mid(-1, x, 121)

	if gotcoin(x+1, y+3, 6, 5, cx+2, cy+3, 4, 5) then 
		sfx(0) score += 1 cx = rnd(112)+8 cy = rnd(32)+70 
	end
end

function gotcoin(x, y, w, h, cx, cy, cw, ch)
	if y > cy + ch then return false end
	if y + h < cy then return false end
	if x > cx + cw then return false end
	if x + w < cx then return false end
	return true
end

-- function gotcoin(x, y, cx, cy)
--  if (x+4) >= cx and (x+4) <= (cx+8) and (y+5) >= (cy+8) and (y+5) <= (cy) then
--      return true
--  end
--  return false
-- end

function _draw()
	cls(12) -- background
	rectfill(0, 112, 128, 128, 1) -- water
	if gf < 120 then
		spr(6, 40, 32) -- l
		spr(7, 46, 32) -- i
		spr(8, 52, 32) -- l
		spr(9, 60, 32) -- b
		spr(10, 66, 32) -- i
		spr(11, 72, 32) -- r
		spr(12, 80, 32) -- d
	end
	spr(s, x, y) -- lil' bird
	if time <= 5 then tcol = 2 end
	if gf >= 120 and time > 0 then
		print(time, 3, 9, tcol)
		spr(5, cx, cy) 
		print(score, 3, 3, 0)
	end
	if gf > 1920 then print("congrats! score: "..score, 3, 3, 0) end
end
