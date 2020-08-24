
-- SoloPong
-- by luisfl.me

function _init()
	cls()
	mode = "start"
	frames = 0 l_color = 7 fx = true
	sfx(4)
end

function _update60()
	if mode == "game" then
		update_game()
	elseif mode == "start" then
		update_start()
	end
	frames += 1
	if frames % 10 == 0 then l_color += 1 end
	if l_color == 16 then l_color = 7 end
end

function update_game()
	local butpress = false
	local nextx, nexty, brickhit
	if btn(0) then
		pad_dx = -3
		butpress = true
		if sticky then
			ball_dx = -1
		end
	end
	if btn(1) then
		pad_dx = 3
		butpress = true
		if sticky then
			ball_dx = 1
		end
	end
	if sticky and btnp(4) then
		sticky = false
	end
	if btnp(5) then if fx == true then sfx(5) end fx = false end
	if btn(5) then pad_dx *= 1.5 else pad_dx *= 1 fx = true end
	if not butpress then
		pad_dx = pad_dx/1.84
	end
	pad_x += pad_dx
	pad_x = mid(0, pad_x, 127-pad_w)
	if sticky then
		ball_x = pad_x + flr(pad_w/2)
		ball_y = pad_y - ball_r - 1
	else
		nextx = ball_x + ball_dx*(chain/23+1)
		nexty = ball_y + ball_dy*(chain/23+1)
		if nextx > 125 or nextx < 2 then
			nextx = mid(2, nextx, 125)
			ball_dx = -ball_dx
			sfx(0)
		end
		if nexty < 2 then
			nexty = mid(2, nexty, 125)
			ball_dy = -ball_dy
			sfx(0)
		end
		if ball_box(nextx, nexty, pad_x, pad_y, pad_w, pad_h) then
			chain += 1
			points += 10*chain
			if deflx_ballbox(ball_x, ball_y, ball_dx, ball_dy, pad_x, pad_y, pad_w, pad_h) then
				ball_dx = -ball_dx
				if ball_x < pad_x + pad_w/2 then
					nextx = pad_x - ball_r
				else
					nextx = pad_x + pad_w + ball_r
				end
			else
				ball_dy = -ball_dy
				if ball_y > pad_y then
					nexty = pad_y + pad_h + ball_r
				else
					nexty = pad_y - ball_r
					if abs(pad_dx) > 2 then
						if sign(pad_dx) == sign(ball_dx) then
							setang(mid(0, ball_ang-1, 2))
						else
							if ball_ang == 2 then
								ball_dx = -ball_dx
							else
								setang(mid(0, ball_ang+1, 2))
							end
						end
					end
				end
			end
			sfx(1)
		end
		ball_x = nextx
		ball_y = nexty
		if nexty > 125 then
			lives -= 1
			chain = 0
			if lives < 0 then
				sfx(3)
				gameover()
			else
				sfx(2)
				serveball()
			end
		end
	end
end

function update_start()
	if btnp(4) or btnp(5) then
		startgame()
	end
end

function startgame()
	mode = "game"
	frames = 0
	ball_r = 2
	ball_dr = 0.5 
	pad_x = 52
	pad_y = 120
	pad_dx = 0
	pad_w = 24
	pad_h = 3
	pad_c = 7
	lives = 3
	points = 0
	chain = 0
	sticky = true
	serveball()
end

function gameover()
	mode = "gameover"
end

function serveball()
	ball_x = pad_x + flr(pad_w/2)
	ball_dx = 2
	ball_y = pad_y - ball_r - 1
	ball_dy = -2
	ball_ang = 1
	chain = 0
	sticky = true
end

function setang(ang)
	ball_ang = ang
	if ang == 2 then
		ball_dx = 1*sign(ball_dx)
		ball_dy = 2.6*sign(ball_dy)
	elseif ang == 0 then
		ball_dx = 2.6*sign(ball_dx)
		ball_dy = 1*sign(ball_dy)
	else
		ball_dx = 2*sign(ball_dx)
		ball_dy = 2*sign(ball_dy)
	end
end

function sign(n)
	if n < 0 then
		return -1
	elseif n > 0 then
		return 1
	else
		return 0
	end
end

function _draw()
	if mode == "game" then
		draw_game()
	elseif mode == "start" then
		draw_start()
	elseif mode == "gameover" then
		draw_gameover()
	end
end

function draw_game()
	local i
	cls(0)
	circfill(ball_x, ball_y, ball_r, 7)
	rectfill(pad_x, pad_y, pad_x+pad_w, pad_y+pad_h, pad_c)
	print(lives, 3, 9, 6)
	print(points, 3, 3, 7)
end

function draw_start()
	cls()
	print("solo pong", 46.5, 56, l_color)
	if frames > 60 then print("press any button", 32.5, 63, 6) end
end

function draw_gameover()
	rectfill(0, 0, 128, 20, 0)
	print("score: "..points, 3, 3, l_color)
end

function ball_box(bx, by, box_x, box_y, box_w, box_h)
	if by - ball_r > box_y + box_h then return false end
	if by + ball_r < box_y then return false end
	if bx - ball_r > box_x + box_w then return false end
	if bx + ball_r < box_x then return false end
	return true
end

function deflx_ballbox(bx, by, bdx, bdy, tx, ty, tw, th)
	local slp = bdy / bdx
	local cx, cy
	if bdx == 0 then
		return false
	elseif bdy == 0 then
		return true
	elseif slp > 0 and bdx > 0 then
		cx = tx - bx
		cy = ty - by
		return cx > 0 and cy/cx < slp
	elseif slp < 0 and bdx > 0 then
		cx = tx - bx
		cy = ty + th - by
		return cx > 0 and cy/cx >= slp
	elseif slp > 0 and bdx < 0 then
		cx = tx + tw - bx
		cy = ty + th - by
		return cx < 0 and cy/cx <= slp
	else
		cx = tx + tw - bx
		cy = ty - by
		return cx < 0 and cy/cx >= slp
	end
end
