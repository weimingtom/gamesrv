require "script.war.hero.init"

cfirehero = class("cfirehero",chero,{
	race = RACE_FIRE,
})

function cfirehero:init(conf)
	chero.init(self,conf)
end

function cfirehero:canuseskill(targetid)
	if not chero.canuseskill(self,targetid) then
		return false
	end
	return true
end

function cfirehero:useskill(targetid)
	chero.useskill(self,targetid)
	local owner = self:getowner()
	owner.enemy.hero:addhp(-2,self.id)
end

return cfirehero
