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