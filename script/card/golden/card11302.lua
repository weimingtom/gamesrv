--<<card 导表开始>>
local super = require "script.card.init"

ccard11302 = class("ccard11302",super,{
    sid = 11302,
    race = 1,
    name = "暴风雪",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
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
    crystalcost = 6,
    targettype = 22,
    desc = "对所有敌方随从造成2点伤害,并使其冻结",
})

function ccard11302:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11302:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11302:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11302:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = self:gethurtvalue()
	warobj.enemy.footman:addhp(-hurtvalue,self.id)
	warobj.enemy.footman:setstate("freeze",1)
end

return ccard11302
