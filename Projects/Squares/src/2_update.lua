function _update60()
	if mode == "game" then updateGame() end
end

function updateGame()

	local dx = 0; local dy = 0; local buttonPress = false

	-- Show image for reference
	if btn(x) or btn(c) then showImage = true
	else showImage = false end
	if showImage then squares = initialSquares
	else squares = randomSquares end

	-- Check if any directional button is pressed (only in this case the empty square can move)
	if btnp(left) or btnp(right) or btnp(up) or btnp(down) then buttonPress = true end

	-- Determine where the empty square should go
	if btnp(left) then dx = 1
	elseif btnp(right) then dx = -1
	elseif btnp(up) then dy = 1
	elseif btnp(down) then dy = -1
	end

	-- Is such movement possible?
	if buttonPress and not showImage then
		if emptySquare.row + dx < 1 or emptySquare.row + dx > size 
		or emptySquare.column + dy < 1 or emptySquare.column + dy > size then
			-- Error sound
		else moveEmptySquare(dx, dy) end
	end

	-- Animate square if enabled
	if squareAnimation.running then
		-- Update moving square
	end

end

-- TODO: enable squareAnimation here
function moveEmptySquare(dx, dy)
	local oldRow = emptySquare.row
	local oldColumn = emptySquare.column
	local newRow = emptySquare.row + dx
	local newColumn = emptySquare.column + dy

	-- Move non-empty square to be replaced
	squares[oldColumn][oldRow] = squares[newColumn][newRow]

	-- Change empty square
	emptySquare.row = newRow
	emptySquare.column = newColumn
end
