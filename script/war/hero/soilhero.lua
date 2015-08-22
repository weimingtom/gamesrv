require "script.war.hero"

csoilhero = class("csoilhero",chero,{
	race = RACE_SOIL,
})

function csoilhero:init(conf)
	chero.init(self,conf)
end

function csoilhero:useskill(target)
	self:adddef(1)
	self:addatk(1)
	chero.useskill(self,target)
end

return csoilhero
