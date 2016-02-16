
chero = class("chero")

function chero.newhero(conf)
	require "script.war.hero.heromodule"
	pprintf("hero.conf:%s",conf)
	local race = conf.race
	local herocls = heromodule[race]
	return herocls.new(conf)
end

function chero:init(conf)
	self.id = conf.id
	self.pid = conf.pid
	self.warid = conf.warid
	self.name = conf.name
	self.maxhp = conf.maxhp or 30
	self.def = conf.def or 0
	self.skillcost = conf.skillcost or 2
	self.hp = self.maxhp
	self.atk = 0
	self.atkcnt = 1
	self.leftatkcnt = 0
	self.buffs = {}
	self.state = {}
end

return chero
