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

