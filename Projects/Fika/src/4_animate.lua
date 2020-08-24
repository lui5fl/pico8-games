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