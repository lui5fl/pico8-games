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