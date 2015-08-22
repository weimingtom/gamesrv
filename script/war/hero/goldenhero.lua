require "script.war.hero"

cgoldenhero = class("cgoldenhero",chero,{
	race = RACE_GOLDEN,
})

function cgoldenhero:init(conf)
	chero.init(self,conf)
end

function cgoldenhero:useskill(target)
	assert(target)
	if target:getstate("magic_immune") then
		return
	end
	target:addhp(-1,self.id)
	chero.useskill(self,target)
end

return cgoldenhero
