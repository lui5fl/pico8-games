function _draw()
	cls(0)
	drawSquares()
	if not showImage then drawBorders() end
end

function drawSquares()
	for j = 1, #squares do
		for i = 1, #squares[j] do
			if i ~= emptySquare.row or j ~= emptySquare.column or showImage then
				sspr(squares[j][i].px, squares[j][i].py, 128/size, 128/size, 32*(i-1), 32*(j-1))
			end
		end
	end
end

function drawBorders()
	for i = 1, 3 do
		rectfill(32*i, 0, 32*i, 128, 0)
		rectfill(0, 32*i, 128, 32*i, 0)
	end
end