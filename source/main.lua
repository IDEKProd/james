-- main.lua
local physics = require("physics")
physics.start()
physics.setGravity(0, 15)
local static = "static"
local moving = true
local movingLeft = false
local movingRight = false
local rounds = 1

local function removeTopScore()
	topScore.isVisible = false
	clock = nil
end

local function startDrop()
	print(rounds)
	physics.removeBody(player)
	physics.addBody(player, "dynamic")
	moving = false
end

local function onLocalCollision(self, event)
	obj1 = event.self
	obj2 = event.other
	if event.phase == "began" then
		if obj2.myName == "catcher1" then
			print("catcher1")
			startDrop()
		elseif obj2.myName == "catcher2" then
			print("catcher2")
			startDrop()
		end
		if obj2.myName == "peg" then
			pointsText.text = pointsText.text + 1
		end
	end
end

local function gameLoop()
	if moving then
		if player.x >= 930 or movingRight then
			movingLeft = false
			movingRight = true
			player.x = player.x - 20
		end
		if player.x <= 30 or movingLeft then
			movingRight = false
			movingLeft = true
			player.x = player.x + 20
		end
	end
	if player.y >= display.contentHeight then
		player.y = 80
		moving = true
		physics.removeBody(player)
		physics.addBody(player, static)
		player.rotation = 0
		rounds = rounds + 1
	end
	if player:getLinearVelocity() == 0 then
		player:setLinearVelocity(math.random(-300, 300), 300)
	end
	if rounds > 3 then
		rounds = 0
		topScore.isVisible = true
		topScore.text = "Your top score was "..pointsText.text
		clock = timer.performWithDelay(5000, removeTopScore)
		pointsText.text = 0
	end
end

local function start()
	--load a score thingies

	topScore = display.newText("", display.contentCenterX, display.contentCenterY, native.systemFont, 75)
	topScore.isVisible = false

	pointsText = display.newText(0, display.contentCenterX, display.contentCenterY, native.systemFont, 750)
	pointsText.alpha = 0.5

	-- load a player

	player = display.newImageRect("character.png", 150, 150)
	player.y = 100
	player.myName = "player"
	physics.addBody(player, static)

	-- load some walls
	local wallLeft = display.newRect(0, display.contentCenterY, 10, display.contentHeight)
	physics.addBody(wallLeft, static)
	local wallRight = display.newRect(display.contentCenterX*2, display.contentCenterY, 10, display.contentHeight)
	physics.addBody(wallRight, static)
	--load some peg in

	--top line
	local peg1 = display.newRect(display.contentCenterX-350, display.contentCenterY-550, 40, 40)
	physics.addBody(peg1, static)
	peg1.myName = "peg"
	local peg2 = display.newRect(display.contentCenterX, display.contentCenterY-550, 40, 40)
	physics.addBody(peg2, static)
	peg2.myName = "peg"
	local peg3 = display.newRect( display.contentCenterX+350, display.contentCenterY-550, 40, 40)
	physics.addBody(peg3, static)
	peg3.myName = "peg"

	-- middle top line

	local peg4 = display.newRect(display.contentCenterX-200, display.contentCenterY-200, 40, 40)
	physics.addBody(peg4, static)
	peg4.myName = "peg"
	local peg5 = display.newRect(display.contentCenterX+200, display.contentCenterY-200, 40, 40)
	physics.addBody(peg5, static)
	peg5.myName = "peg"
	--middle bottom line

	local peg6 = display.newRect(display.contentCenterX-350, display.contentCenterY+200, 40, 40)
	physics.addBody(peg6, static)
	peg6.myName = "peg"
	local peg7 = display.newRect(display.contentCenterX, display.contentCenterY+200, 40, 40)
	physics.addBody(peg7, static)
	peg7.myName = "peg"
	local peg8 = display.newRect(display.contentCenterX+350, display.contentCenterY+200, 40, 40)
	physics.addBody(peg8, static)
	peg8.myName = "peg"

	-- bottom line
	local peg9 = display.newRect(display.contentCenterX-200, display.contentCenterY+550, 40, 40)
	physics.addBody(peg9, static)
	peg9.myName = "peg"
	local peg10 = display.newRect( display.contentCenterX+200, display.contentCenterY+550, 40, 40)
	physics.addBody(peg10, static)
	peg10.myName = "peg"

	-- load some catchers in the bottom

	local catcher1 = display.newRect(display.contentCenterX-200, display.contentCenterY*2-40, 150, 40)
	catcher1.myName = "catcher1"
	physics.addBody(catcher1, static, {isSensor = true})
	local catcher2 = display.newRect( display.contentCenterX+200, display.contentCenterY*2-40, 150, 40)
	catcher2.myName = "catcher2"
	physics.addBody(catcher2, static, {isSensor = true})

	player.collision = onLocalCollision
	player:addEventListener("collision")
	Runtime:addEventListener("enterFrame", gameLoop)
	Runtime:addEventListener("tap", startDrop)
end

start()