-- drawIntro
function drawBird()
	spr(240-16*(flr(intro.frames/15)%2), intro.x, intro.y)
end

function drawWordmark()
	sspr(9, 120, 19, 5, intro.x + 9, intro.y, 19, 5)
end