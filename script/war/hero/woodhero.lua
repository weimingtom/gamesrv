require "script.war.hero.init"
require "script.war.warmgr"

cwoodhero = class("cwoodhero",chero,{
	race = RACE_WOOD,
})

function cwoodhero:init(conf)
	chero.init(self,conf)
end

function cwoodhero:canuseskill(targetid)
	if not chero.canuseskill(self,targetid) then
		return false
	end
	local owner = self:getowner()
	if owner:getfreespace("warcard") <= 0 then
		return false
	end
	return true
end

function cwoodhero:useskill(targetid)
	chero.useskill(self,targetid)
	local owner = self:getowner()
	local warcard = owner:newwarcard(126002)
	owner:putinwar(warcard)
end

return cwoodhero
