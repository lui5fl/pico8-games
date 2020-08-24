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