require "script.war.hero"
require "script.war.warmgr"

cwoodhero = class("cwoodhero",chero,{
	race = RACE_WOOD,
})

function cwoodhero:init(conf)
	chero.init(self,conf)
end

function cwoodhero:useskill(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard = warobj:newwarcard(12602)
	warobj:putinwar(warcard)
	chero.useskill(self,target)
end

return cwoodhero
