--<<card 导表开始>>
local super = require "script.card"

ccard14405 = class("ccard14405",super,{
    sid = 14405,
    race = 4,
    name = "爆炸陷阱",
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
    magic_hurt = 2,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "奥秘：当你的英雄受到攻击时,对所有敌人造成2点伤害。",
})

function ccard14405:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14405:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14405:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14405:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"ondefense",self.id)
end

function ccard14405:__ondefense(attacker,defenser)
	local war = warmgr.getwar(self.warid)	
	local warobj = war:getwarobj(self.pid)
	warobj:delsecret(self.id,"trigger")
	unregister(warobj.hero,"ondefense",self.id)
	local hurtvalue = self:gethurtvalue()
	local warcard
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		warcard:addhp(-hurtvalue,self.id)
	end
	warobj.enemy.hero:addhp(-hurtvalue,self.id)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end
return ccard14405
