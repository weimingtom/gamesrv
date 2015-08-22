require "script.war.hero"
require "script.war.warmgr"

cfirehero = class("cfirehero",chero,{
	race = RACE_FIRE,
})

function cfirehero:init(conf)
	chero.init(self,conf)
end

function cfirehero:useskill(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.enemy.hero:addhp(-2,self.id)
	chero.useskill(self,target)
end

return cfirehero
