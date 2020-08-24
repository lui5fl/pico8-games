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