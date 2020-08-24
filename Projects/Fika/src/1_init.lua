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