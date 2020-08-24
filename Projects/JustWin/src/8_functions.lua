function closestPlatform(player)
	local y = 113
	for i = 1, #platforms[platform] do
		if platforms[platform][i][1] < players[player].x + 8 and platforms[platform][i][1] + platforms[platform][i][3] > players[player].x and
		platforms[platform][i][2] > players[player].y + 4 then
			if y > platforms[platform][i][2] - 8 then y = platforms[platform][i][2] - 8 end
		end
	end
	return y
end

function getBestPlayer()
	local best = 1
	for i = 2, #players do if players[best].p < players[i].p then best = i end end
	return best
end