
-- Squares
-- by luisfl.me
-- Compiled: 24/08/20 13:06:23

-- 1_init.lua

function _init()
	-- Buttons
	left = 0; right = 1; up = 2; down = 3
	x = 4; c = 5

	mode = "game"

	-- Number of squares = size * size (preferably a divisor of 128)
	size = 4

	initialSquares = initSquares()
	randomSquares = randomizeSquares(initialSquares)
	squares = randomSquares

	-- Empty/black square
	emptySquare = {}
	emptySquare.row = size
	emptySquare.column = size

	-- Square movement animation
	squareAnimation = {}
	squareAnimation.running = false
	squareAnimation.row = -1
	squareAnimation.column = -1
	squareAnimation.nextX = -1
	squareAnimation.nextY = -1
end

function initSquares()
	local squares = {}
	for j = 1, size do
		local row = {}
		for i = 1, size do
			local square = {}
			square.id = i + 4 * (j - 1)
			square.px = 32 * (i - 1)
			square.py = 32 * (j - 1)
			add(row, square)
		end
		add(squares, row)
	end
	return squares
end

function randomizeSquares(squares)
	local randomSquares = {}
	local randomCoords = {}

	for i = 1, size do
		for j = 1, size do
			if i ~= size or j ~= size then
				add(randomCoords, {i, j})
			end
		end
	end

	for i = 1, #squares do
		randomSquares[i] = {}
		for j = 1, #squares[i] do
			if #randomCoords > 0 then
				local randomCoord = randomCoords[flr(rnd(#randomCoords)) + 1]
				local row = randomCoord[1]; local column = randomCoord[2]
				add(randomSquares[i], squares[row][column])
				del(randomCoords, randomCoord)
			end
		end
	end

	return randomSquares
end

-- 2_update.lua

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


-- 4_draw.lua

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
