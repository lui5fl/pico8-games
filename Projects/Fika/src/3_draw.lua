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