require "script.war.hero.init"

cwaterhero = class("cwaterhero",chero,{
	race = RACE_WATER,
})

function cwaterhero:init(conf)
	chero.init(self,conf)
end

function cwaterhero:canuseskill(targetid)
	if not chero.canuseskill(self,targetid) then
		return false
	end
	return true
end

function cwaterhero:useskill(targetid)
	chero.useskill(self,targetid)
	local owner = self:getowner()
	local recoverhp = owner:getrecoverhp(2)
	target:addhp(recoverhp,self.id)
end

return cwaterhero
