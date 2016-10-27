-- main.lua
local physics = require("physics")
physics.start()
physics.setGravity(0, 15)
local static = "static"
local moving = true
local movingLeft = false
local movingRight = false

local function startDrop()
	physics.removeBody(player)
	physics.addBody(player, "dynamic")
	moving = false
end

local function onLocalCollision(self, event)
	obj1 = event.self
	obj2 = event.other
	if obj2.myName == "catcher1" then
		print("catcher1")
		startDrop()
	elseif obj2.myName == "catcher2" then
		print("catcher2")
		startDrop()
	elseif obj2.myName == "catcher3" then
		print("catcher3")
		startDrop()
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
	end
	if player:getLinearVelocity() == 0 then
		player:setLinearVelocity(50, 20)
	end
end

local function start()
	-- load a player

	player = display.newRect(10, 80, 80, 80)
	player.myName = "player"
	physics.addBody(player, static)

	-- load some walls
	local wallLeft = display.newRect(0, display.contentCenterY, 10, display.contentHeight)
	physics.addBody(wallLeft, static)
	local wallRight = display.newRect(display.contentCenterX*2, display.contentCenterY, 10, display.contentHeight)
	physics.addBody(wallRight, static)
	--load some peg in

	local peg1 = display.newRect(display.contentCenterX-350, display.contentCenterY-550, 20, 20)
	physics.addBody(peg1, static)
	local peg2 = display.newRect(display.contentCenterX, display.contentCenterY-550, 20, 20)
	physics.addBody(peg2, static)
	local peg3 = display.newRect( display.contentCenterX+350, display.contentCenterY-550, 20, 20)
	physics.addBody(peg3, static)
	local peg4 = display.newRect(display.contentCenterX-200, display.contentCenterY-200, 20, 20)
	physics.addBody(peg4, static)
	local peg5 = display.newRect(display.contentCenterX+200, display.contentCenterY-200, 20, 20)
	physics.addBody(peg5, static)
	local peg6 = display.newRect(display.contentCenterX-350, display.contentCenterY+200, 20, 20)
	physics.addBody(peg6, static)
	local peg7 = display.newRect(display.contentCenterX, display.contentCenterY+200, 20, 20)
	physics.addBody(peg7, static)
	local peg8 = display.newRect(display.contentCenterX+350, display.contentCenterY+200, 20, 20)
	physics.addBody(peg8, static)
	local peg9 = display.newRect(display.contentCenterX-200, display.contentCenterY+550, 20, 20)
	physics.addBody(peg9, static)
	local peg10 = display.newRect( display.contentCenterX+200, display.contentCenterY+550, 20, 20)
	physics.addBody(peg10, static)

	-- load some catchers in the bottom

	local catcher1 = display.newRect(display.contentCenterX+350, display.contentCenterY*2, 200, 20)
	catcher1.myName = "catcher1"
	physics.addBody(catcher1, static, {isSensor = true})
	local catcher2 = display.newRect( display.contentCenterX, display.contentCenterY*2, 200, 20)
	catcher2.myName = "catcher2"
	physics.addBody(catcher2, static, {isSensor = true})
	local catcher3 = display.newRect( display.contentCenterX-350, display.contentCenterY*2, 200, 20)
	catcher3.myName = "catcher3"
	physics.addBody(catcher3, static, {isSensor = true})

	player.collision = onLocalCollision
	player:addEventListener("collision")
	Runtime:addEventListener("enterFrame", gameLoop)
	Runtime:addEventListener("tap", startDrop)
end

start()