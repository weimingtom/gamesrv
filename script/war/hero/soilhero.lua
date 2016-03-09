require "script.war.hero"

csoilhero = class("csoilhero",chero,{
	race = RACE_SOIL,
})

function csoilhero:init(conf)
	chero.init(self,conf)
end

function csoilhero:canuseskill(targetid)
	if not chero.canuseskill(self,targetid) then
		return false
	end
	return true
end

function csoilhero:useskill(targetid)
	chero.useskill(self,targetid)
	self:adddef(1)
	self:addatk(1)
end

return csoilhero
