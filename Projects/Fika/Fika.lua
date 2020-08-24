
-- Fika
-- by luisfl.me
-- Compiled: 24/08/20 13:00:50

-- 1_init.lua

function _init()
	-- Change transparent color to other than black
	palt(15, true) palt(0, false)

	game = {}
	game.frames = 0
	game.animating = false
	game.animatingBackwards = false

	-- Intro
	intro = {}
	intro.x = 48
	intro.y = 61

	-- Menu
	initMenu()

	-- Player
	player = {}
	player.coins = 5430

	-- Shop
	shop = {}
	shop.weapons = {}
	shop.weapons.names = { 
		"The Sword", 
		"Infinite Bow", 
		"Huge Bomb", 
		"Snake Whip",
		"Water Pistol",
		"Schrodinger's Void",
		"Aikon",
		"E" 
	}
	shop.weapons.infos = { 
		"The only sword in the game.", 
		"Never runs out of arrows.", 
		"In awe at the size of this", 
		"A dead snake I found near a", 
		"Why are you laughing?",
		"I haven't tried it yet!",
		"Definitely not a dangerous",
		"Absurdly wonderful, just"
	}
	shop.weapons.infos2 = { 
		"Hence the 'The'", 
		"How? No one knows.", 
		"lad. Absolute unit.", 
		"river.",
		"",
		"Let me know what it does.",
		"finnish mobile phone.",
		"like the meme."
	} 
	shop.weapons.prices = { 300, 750, 1400, 3000, 5000, 7500, 10000, 22222 }
	shop.weapons.icons = { 0, 10, 20, 30, 40, 50, 60, 70 }
	shop.weaponsX = { 56, 76, 96, 116, 136, 156, 176, 196 }
	shop.nextWeaponsX = { 56, 76, 96, 116, 136, 156, 176, 196 }
	shop.y = 128
	shop.option = 1
	shop.count = 8
	shop.frames = 0
	shop.startFrames = false

	-- Sounds
	sound = {}
	sound.intro = 0
	sound.block = 11
	sound.menuDown = 4
	sound.menuUp = 5
	sound.playButton = 6
	sound.shopButton = 7
	sound.helpButton = 8
	sound.belowButton = 9
	sound.cancel = 10
	sound.music = {}
	sound.music.stop = -1
	sound.music.menu = 0
	sound.music.shop = 24
	sound.music.help = 20
	sound.flag = {}
	sound.flag[0] = true
	
	-- { "intro", "menu", "play", "shop", "help", "game", "pause", "end" }
	game.mode = "intro"
end

-- initMenu
function initMenu()
	menu = {}
	menu.option = 1
	menu.options = { "play", "shop", "help" }
	menu.count = 3
	menu.x = { 20, 10, 10 }
	menu.y = { 0, 13, 26 }
	menu.width = { 30, 30, 30 }
	menu.height = { 11, 11, 11 }
	menu.defaultX = 10
	menu.animatedX = 20
	menu.initialY = 79
	menu.topBarY = -31
	menu.arrow = {}
	menu.arrow.x = 11
	menu.arrow.y = 81
	menu.arrow.offsetX = 0
	menu.arrow.frames = 0
	menu.arrow.spr = 4
end

-- 2_update.lua

function _update60()
	if game.mode == "intro" then updateIntro()
	elseif game.mode == "menu" then updateMenu() 
	elseif game.mode == "play" then updateMenuPlay()
	elseif game.mode == "shop" then updateMenuShop()
	elseif game.mode == "help" then updateMenuHelp() end
end

-- updateIntro()
function updateIntro()
	if sound.flag[sound.intro] then sfx(sound.intro) sound.flag[sound.intro] = false end
	if game.frames < 59 then game.frames += 1
	else game.frames = 0 game.mode = "menu" music(sound.music.menu) end
end

-- updateMenu
function updateMenu()
	if not(game.animating) and not(game.animatingBackwards) then
		-- Down and Up Buttons
		if btnp(2) then switchToMenuOption(-1)
		elseif btnp(3) then switchToMenuOption(1) end
		-- Press C Key
		if btnp(4) then selectMenuOption() end
	end
	updateMenuArrow()
end

function switchToMenuOption(num)
	menu.option += num
	if num > 0 then sfx(sound.menuDown) else sfx(sound.menuUp) end
	if menu.option > 3 then menu.option = 1
	elseif menu.option < 1 then menu.option = 3 end
end

function selectMenuOption()
	game.animating = true
	sfx(sound.belowButton)
	music(sound.music.stop, 1000)
	if menu.option == 1 then sfx(sound.playButton)
	elseif menu.option == 2 then sfx(sound.shopButton)
	elseif menu.option == 3 then sfx(sound.helpButton) end
end

function backToMenu()
	game.animatingBackwards = true
	shop.startFrames = false
	shop.frames = 0
	music(sound.music.stop, 300)
	sfx(sound.belowButton) sfx(sound.cancel)
end

function updateMenuArrow()
	menu.arrow.frames += 1
	if menu.arrow.frames > 47 then menu.arrow.frames = 0 end
end

-- updateMenuPlay
function updateMenuPlay()
	if not(game.animating) and not(game.animatingBackwards) then
		if btnp(5) then backToMenu() end
	end
	updateMenuArrow()
end

-- updateMenuShop
function updateMenuShop()
	if not(game.animating) and not(game.animatingBackwards) then
		if btnp(0) then switchToShopOption(-1)
		elseif btnp(1) then switchToShopOption(1)
		elseif btnp(5) then backToMenu() end
	end
	if shop.startFrames then shop.frames += 1 end
	if shop.frames > 51 then shop.frames = 0 else end
	updateMenuArrow()
end

function switchToShopOption(num)
	shop.option += num
	if shop.option > shop.count then sfx(sound.block) shop.option = shop.count
	elseif shop.option < 1 then sfx(sound.block) shop.option = 1
	else
		if num > 0 then sfx(sound.menuDown) else sfx(sound.menuUp) end
		for i = 1, shop.count do
			if num > 0 then shop.nextWeaponsX[i] -= 20
			elseif num < 0 then shop.nextWeaponsX[i] += 20 end
		end
	end
end

-- updateMenuHelp
function updateMenuHelp()
	if not(game.animating) and not(game.animatingBackwards) then
		if btnp(5) then backToMenu() end
	end
	updateMenuArrow()
end



-- 3_draw.lua

function _draw()
	cls()
	if game.mode == "intro" then drawIntro()
	elseif game.mode == "menu" then drawMenu() 
	elseif game.mode == "play" then drawMenuPlay()
	elseif game.mode == "shop" then drawMenuShop()
	elseif game.mode == "help" then drawMenuHelp() end
end

-- drawIntro
function drawIntro()
	drawBird()
	drawWordmark()
end

function drawBird()
	spr(240-16*(flr(game.frames/15)%2), intro.x, intro.y)
end

function drawWordmark()
	sspr(9, 120, 19, 5, intro.x + 9, intro.y, 19, 5)
end

-- drawMenu
function drawMenu()
	drawMenuOptions()
	drawMenuArrow()
	drawMenuTopBar()
	animateMenu()
	animateMenuTransition()
end

function drawMenuOption()
	drawMenu()
	animateMenuTransitionBackwards()
end

function drawMenuPlay() 
	drawMenuOption()
end

function drawMenuShop()
	drawMenuShopInterface()
	drawMenuOption()
	animateShopOptions()
end

function drawMenuShopInterface()
	spr(113, 60, shop.y + 26)
	local itemPriceX = 115
	local coins = 0
	-- Item Description
	spr(14, 6, shop.y + 29) spr(15, 114, shop.y + 29)
	spr(30, 6, shop.y + 43) spr(31, 114, shop.y + 43)
	rectfill(6, shop.y + 31, 121, shop.y + 48, 7)
	rectfill(8, shop.y + 29, 119, shop.y + 50, 7)
	for i = 1, shop.count do
		coins = shop.weapons.prices[i]
		if i == shop.option then 
			if shop.weapons.prices[i] > player.coins then
				sspr(112, 16, 16, 16, shop.weaponsX[i], shop.y + 6, 16, 16)
			else
				sspr(112, 0, 16, 16, shop.weaponsX[i], shop.y + 6, 16, 16)
			end
			sspr(shop.weapons.icons[i], 80, 10, 10, shop.weaponsX[i] + 3, shop.y + 9, 10, 10) 
			print(shop.weapons.names[i], 10, shop.y + 33, 0)
			if shop.weapons.infos2[i] != "" then
				rectfill(6, shop.y + 48, 121, shop.y + 55, 7)
				rectfill(8, shop.y + 46, 119, shop.y + 57, 7)
				spr(30, 6, shop.y + 50) spr(31, 114, shop.y + 50)
				print(shop.weapons.infos2[i], 10, shop.y + 49, 5)
			end
			print(shop.weapons.infos[i], 10, shop.y + 42, 5)
			-- Price
			while(coins >= 10) do coins /= 10 itemPriceX -= 4 end
			print(shop.weapons.prices[i], itemPriceX, shop.y + 33, 0)
			spr(11, itemPriceX - 7, shop.y + 33)
		else 
			if shop.weapons.prices[i] > player.coins then
				sspr(96, 16, 16, 16, shop.weaponsX[i], shop.y + 6, 16, 16) 
				sspr(shop.weapons.icons[i], 96, 10, 10, shop.weaponsX[i] + 3, shop.y + 9, 10, 10)
			else
				sspr(96, 0, 16, 16, shop.weaponsX[i], shop.y + 6, 16, 16) 
				sspr(shop.weapons.icons[i], 64, 10, 10, shop.weaponsX[i] + 3, shop.y + 9, 10, 10)
			end 
		end
	end
	-- Bolsa
	sspr(64+16*flr(shop.frames/26), 48, 16, 16, 56, shop.y + 70, 16, 16)
	-- Buttons
	print("🅾️", 30, shop.y + 71, 7) print("Menu", 26, shop.y + 80, 7)
	if shop.weapons.prices[shop.option] > player.coins then
		print("❎", 91, shop.y + 71, 5) print("Buy!", 88, shop.y + 80, 5)
	else print("❎", 91, shop.y + 71, 7) print("Buy!", 88, shop.y + 80, 7) end
end

function drawMenuHelp() 
	drawMenuOption()
end

function drawMenuOptions()
	local settings = { 8, 20 }
	for i = 1, menu.count do
		if menu.option == i then settings = { 20, 24 }
		else settings = { 8, 20 } end
		-- Rectangle
		sspr(0, settings[1], 11, 11, menu.x[i], menu.initialY + menu.y[i], 11, menu.height[i])
		sspr(16, settings[1], 11, 11, menu.x[i] + 40, menu.initialY + menu.y[i], 11, menu.height[i])
		sspr(8, settings[1], 11, 11, menu.x[i] + 10, menu.initialY + menu.y[i], menu.width[i], menu.height[i])
		-- 4 Letters
		for j = 0, 3 do spr(settings[2]+j+16*(i-1), menu.x[i]+3+8*j, menu.initialY + menu.y[i]+2) end
	end
end

function drawMenuArrow()
	spr(menu.arrow.spr + flr(menu.arrow.frames/8), menu.arrow.x + menu.arrow.offsetX, menu.arrow.y)
end

function drawMenuTopBar()
	rectfill(0, menu.topBarY, 128, menu.topBarY + 30, 7)
	local i = 1
	local shopCoinsX = 115
	local coins = player.coins
	if game.mode == "play" then 
		i = 1
	elseif game.mode == "shop" then 
		i = 2
		while(coins >= 10) do coins /= 10 shopCoinsX -= 4 end
		print(player.coins, shopCoinsX, menu.topBarY + 22, 0)
		spr(11, shopCoinsX - 7, menu.topBarY + 22)
	elseif game.mode == "help" then i = 3 end
	for j = 0, 3 do spr(24+j+16*(i-1), 10+8*j, menu.topBarY+21) end
end

-- 4_animate.lua

-- animateMenu
function animateMenu()
	animateMenuOptions()
	animateMenuArrow()
end

function animateMenuOptions()
	if not(game.animating) then
		for i = 1, menu.count do
			if menu.option == i then
				if menu.x[i] < menu.animatedX then menu.x[i] += 2 end
			else
				if menu.x[i] > menu.defaultX then menu.x[i] -= 2 end
			end
		end
	end
end

function animateMenuArrow()
	if menu.arrow.y < menu.initialY + menu.y[menu.option] + 2 then 
		menu.arrow.y += 6.5
	elseif menu.arrow.y > menu.initialY + menu.y[menu.option] + 2 then 
		menu.arrow.y -= 6.5
	end
	if menu.arrow.frames < 24 then menu.arrow.x += 0.07
	else menu.arrow.x -= 0.07 end
	if game.animating and menu.arrow.x > -12 then menu.arrow.x -= 0.84
	elseif game.animatingBackwards and menu.arrow.x < 11 then menu.arrow.x += 0.84 end
end

-- animateMenuTransition()
function animateMenuTransition()
	if game.animating then
		for i = 1, menu.count do
			if menu.option == i then
				game.mode = menu.options[i]
				if menu.x[i] < menu.defaultX + 125 then menu.x[i] += 3 end
				if shop.y > 30.05 then shop.y -= 2 * shop.y/98 end
				if menu.topBarY < -0.05 then menu.topBarY += 2.5 * menu.topBarY/(-30)
				else 
					game.animating = false
					if game.mode == "shop" then shop.startFrames = true music(sound.music.shop)
					elseif game.mode == "help" then music(sound.music.help) end
				end
			else
				if menu.x[i] > menu.defaultX - 70 then menu.x[i] -= 3 end
			end 
		end
	end
end

function animateMenuTransitionBackwards()
	if game.animatingBackwards then
		for i = 1, menu.count do
			if menu.option == i then
				if menu.x[i] > menu.animatedX then menu.x[i] -= 3
				else 
					game.animatingBackwards = false
					game.mode = "menu" 
					music(sound.music.menu) 
				end
				if menu.topBarY > -30.95 then menu.topBarY -= 2.5 * (menu.topBarY - 1)/(-15) end
				if shop.y < 127.95 then shop.y += 5 * shop.y/98 end
			else
				if menu.x[i] < menu.defaultX then menu.x[i] += 3 end
			end 
		end
	end
end

function animateShopOptions()
	for i = 1, shop.count do
		if shop.weaponsX[i] > shop.nextWeaponsX[i] then shop.weaponsX[i] -= 2
		elseif shop.weaponsX[i] < shop.nextWeaponsX[i] then shop.weaponsX[i] += 2 end
	end
end
