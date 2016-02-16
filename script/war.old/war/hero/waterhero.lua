require "script.war.hero"

cwaterhero = class("cwaterhero",chero,{
	race = RACE_WATER,
})

function cwaterhero:init(conf)
	chero.init(self,conf)
	self.cure_multiple = 1
end

function cwaterhero:set_cure_multiple(value)
	logger.log("debug","war",string.format("[warid=%d] #%d hero.set_cure_multiple %d",self.warid,self.pid,value))
	warmgr.refreshwar(self.warid,self.pid,"set_hero_cure_mutiple",{value=value,})
end

function cwaterhero:useskill(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local recoverhp = warobj:getrecoverhp(2) * self.cure_multiple
	target:addhp(recoverhp,self.id)
	chero.useskill(self,target)
end

return cwaterhero
