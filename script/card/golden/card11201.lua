--<<card 导表开始>>
local super = require "script.card"

ccard11201 = class("ccard11201",super,{
    sid = 11201,
    race = 1,
    name = "寒冰屏障",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 11,
    desc = "奥秘：当你的英雄将要承受致命伤害时,防止这些伤害,并使其在本回合免疫",
})

function ccard11201:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11201:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11201:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"


function ccard11201:__ondefense(attacker,defenser)
	local hero = defenser
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if hero:gethp() <= attacker:gethurtvalue() then
		warobj:delsecret(self.id,"trigger")	
		unregister(hero,"ondefense",self.id)
		hero:setstate("immune",1)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard11201:onuse(target)
	local war = warmgr.getwar(self.warid)	
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"ondefense",self.id)
end

return ccard11201
