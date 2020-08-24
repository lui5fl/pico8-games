function createPlayer(id, x, points)
	local p = {}

	-- Position
	p.x = x
	p.y = 113

	-- Movement
	p.dx = 0
	p.dy = 0

	-- Direction
	p.d = 1

	-- Sounds
	p.sounds = {}
	p.sounds.jump = true
	p.sounds.floor = false

	-- Jump Variables
	p.j = 2
	p.f = false
	p.jumpFrames = -1
	p.enableJumpFrames = false

	-- Rounds Won
	p.p = points

	-- Visible
	p.v = true

	players[id] = p
end

function initPlayersPoints()
	for i = 1, #players do
		players[i].p = 0
	end
end

function createProjectile(player, direction)
	local p = {}
	p.p = player
	p.x = players[player].x + 4
	p.y = players[player].y + 4
	p.d = direction
	p.v = true
	add(projectiles, p)
end