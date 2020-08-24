
-- Connect4
-- by luisfl.me

function _init()
	cls()
	mode = "start"
	sfx(0)
	frames = 0
	circ = {{}, {}, {}, {}, {}, {}, {}}
	circ.size = 7
	arrow = {}
	arrow.x = {6, 24, 42, 60, 78, 96, 114}
	column = 4
	player1 = true
	color = 12
	prevcolumn = 4 prevrow = 6
	playend = true
	tie = false
	make_circles()
end

function mode_game() mode = "game" end
function mode_end() mode = "end" end

function _update60()
	if frames < 62 then frames += 1 end
	if frames == 60 then mode_game() end
	if mode == "game" then update_game() end
end

function update_game()
	update_arrow()
	if win() then if playend then sfx(4) playend = false end mode_end() end
	if not(not_full()) then if playend then sfx(5) playend = false end tie = true mode_end() end
	if free_circle() != nil then
		prevcolumn = column prevrow = free_circle()
	end
	if player1 then color = 12 else color = 8 end
	if btnp(4) then
		if free_circle() != nil then
			sfx(2)
			circ[column][free_circle()].c = color
			circ[column][free_circle()].s = true
			player1 = not(player1)
		else sfx(3) end
	end
end

function update_arrow()
	if btnp(0) then sfx(1) column -= 1 end
	if btnp(1) then sfx(1) column += 1 end
	if column < 1 then column = 7 elseif column > 7 then column = 1 end
end

function _draw()
	cls()
	draw_circ()
	if mode != "start" then 
		if mode != "end" then 
			draw_placeholder()
			spr(0, arrow.x[column], 7) 
		else
			if tie then print("tie!", 57, 5, 7)
			else
				if not(player1) then print("blue wins!", 45, 5, 12)
				else print("red wins!", 47, 5, 8) end
			end
		end
	else print(">", 42, 5, 12) print("connect4", 48, 5, 7) print("<", 82, 5, 8) end
end

function draw_circ()
	for i = 1, 7 do
		for j = 1, 6 do circfill(circ[i][j].x, circ[i][j].y, circ.size, circ[i][j].c) end
	end
end

function draw_placeholder()
	if free_circle() != nil then
		circfill(circ[prevcolumn][prevrow].x, circ[prevcolumn][prevrow].y, circ.size/2, color)
	end
end

function make_circles()
	for i = 1, 7 do
		for j = 1, 6 do
			local c = {}
			c.x = 9+18*(i-1)
			c.y = 23+18*(j-1)
			c.c = 7
			c.s = false
			add(circ[i], c)
		end
	end
end

function free_circle()
	for i = 1, 6 do
		if not(circ[column][7-i].s) then return 7-i end
	end
end

function not_full()
	for i = 1, 7 do
		for j = 1, 6 do
			if not(circ[i][j].s) then return true end
		end
	end
end

function win()
	if h_win() or v_win() or d_win() then return true end
end

function h_win()
	for i = 1, 6 do
		if (circ[1][i].c == 12 and circ[2][i].c == 12 and circ[3][i].c == 12 and circ[4][i].c == 12) or
		   (circ[2][i].c == 12 and circ[3][i].c == 12 and circ[4][i].c == 12 and circ[5][i].c == 12) or
		   (circ[3][i].c == 12 and circ[4][i].c == 12 and circ[5][i].c == 12 and circ[6][i].c == 12) or
		   (circ[4][i].c == 12 and circ[5][i].c == 12 and circ[6][i].c == 12 and circ[7][i].c == 12) or
		   (circ[1][i].c == 8 and circ[2][i].c == 8 and circ[3][i].c == 8 and circ[4][i].c == 8) or
		   (circ[2][i].c == 8 and circ[3][i].c == 8 and circ[4][i].c == 8 and circ[5][i].c == 8) or
		   (circ[3][i].c == 8 and circ[4][i].c == 8 and circ[5][i].c == 8 and circ[6][i].c == 8) or
		   (circ[4][i].c == 8 and circ[5][i].c == 8 and circ[6][i].c == 8 and circ[7][i].c == 8) then return true end
	end
end

function v_win()
	for i = 1, 7 do
		if (circ[i][1].c == 12 and circ[i][2].c == 12 and circ[i][3].c == 12 and circ[i][4].c == 12) or
		   (circ[i][2].c == 12 and circ[i][3].c == 12 and circ[i][4].c == 12 and circ[i][5].c == 12) or
		   (circ[i][3].c == 12 and circ[i][4].c == 12 and circ[i][5].c == 12 and circ[i][6].c == 12) or
		   (circ[i][1].c == 8 and circ[i][2].c == 8 and circ[i][3].c == 8 and circ[i][4].c == 8) or
		   (circ[i][2].c == 8 and circ[i][3].c == 8 and circ[i][4].c == 8 and circ[i][5].c == 8) or
		   (circ[i][3].c == 8 and circ[i][4].c == 8 and circ[i][5].c == 8 and circ[i][6].c == 8) then return true end
	end
end

function d_win()
	for i = 1, 4 do
		for j = 1, 3 do
			if (circ[i][j].c == 12 and circ[i+1][j+1].c == 12 and circ[i+2][j+2].c == 12 and circ[i+3][j+3].c == 12) or
			   (circ[i][j].c == 8 and circ[i+1][j+1].c == 8 and circ[i+2][j+2].c == 8 and circ[i+3][j+3].c == 8) or
			   (circ[8-i][j].c == 12 and circ[8-i-1][j+1].c == 12 and circ[8-i-2][j+2].c == 12 and circ[8-i-3][j+3].c == 12) or
			   (circ[8-i][j].c == 8 and circ[8-i-1][j+1].c == 8 and circ[8-i-2][j+2].c == 8 and circ[8-i-3][j+3].c == 8) then return true end
		end
	end
end
