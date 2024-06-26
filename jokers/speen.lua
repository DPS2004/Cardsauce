local mod = SMODS.findModByID('Cardsauce')

mod.speenTimer = 0

mod.speenBase = love.graphics.newImage(mod.path..'assets/1x/speenBase.png')
mod.speenFace = love.graphics.newImage(mod.path..'assets/1x/speenFace.png')

local drawFace = function()
	local r = math.sin(mod.speenTimer/2) * 60
	local sx = math.sin(mod.speenTimer*4)
	love.graphics.draw(mod.speenFace,71/2,95/2,r,sx,1,71/2,95/2)
end

local setupCanvas = function(self)
	self.children.center.video = love.graphics.newCanvas(71,95)
	self.children.center.video:renderTo(function()
		love.graphics.clear(1,1,1,0) 
		love.graphics.setColor(1,1,1,1)
		--Draw the base, then the face
		love.graphics.draw(mod.speenBase)
		drawFace()
	end)
end


local jokerInfo = {
	name = 'SPEEEEEEN [WIP]',
	config = {},
	text = {
		"Create a {C:purple}Wheel of Fortune{} card",
		"when {C:attention}rerolling{} in the shop",
		"{C:inactive}(Must have room){}",
	},
	rarity = 1,
	cost = 6,
	canBlueprint = true,
	canEternal = true
}

function jokerInfo.tooltip(self, info_queue)
	info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
	info_queue[#info_queue+1] = {key = "guestartist2", set = "Other"}
end

--[[
function jokerInfo.locDef(self)
	return {self.ability.extra.mult}
end
]]--

function jokerInfo.init(self)
	self.ability.extra = {
	}
	setupCanvas(self)
end

function jokerInfo.calculate(self, context)
	--todo
end

function jokerInfo.update(self, dt)
end

local loveUpdateReference = love.update

function love.update(dt)
	if mod.speenTimer and G.SETTINGS.GAMESPEED then
		mod.speenTimer = (mod.speenTimer + (dt / G.SETTINGS.GAMESPEED)) % (math.pi * 4)
	end
	loveUpdateReference(dt)
end

function jokerInfo.draw(self,layer)
	--Withouth love.graphics.push, .pop, and .reset, it will attempt to use values from the rest of 
	--the rendering code. We need a clean slate for rendering to canvases.
	love.graphics.push('all')
		love.graphics.reset()
		if not self.children.center.video then
			--Sometimes, such as when a game is saved and loaded, the canvas gets de-initialized.
			--We need to check for this, and re-initialize it.
			setupCanvas(self)
		end
		
		self.children.center.video:renderTo(function()
			--Same as before, but this time we pass in the timer.
			love.graphics.draw(mod.speenBase)
			drawFace(self.ability.extra.timer)
		end)
	love.graphics.pop()
end



return jokerInfo
	