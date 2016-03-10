require "script.war.hero.init"

cgoldenhero = class("cgoldenhero",chero,{
	race = RACE_GOLDEN,
})

function cgoldenhero:init(conf)
	chero.init(self,conf)
end

function cgoldenhero:canuseskill(targetid)
	if not chero.canuseskill(self,targetid) then
		return false
	end
	local owner = self:getowner()
	local target = owner:gettarget(targetid)
	if target:getstate("immune") then
		return false
	end
	if target:getstate("magic_immune") then
		return false
	end
	return true
end

function cgoldenhero:useskill(targetid)
	chero.useskill(self,targetid)
	local owner = self:getowner()
	local target = owner:gettarget(targetid)
	target:addhp(-1,self.id)
end

return cgoldenhero
