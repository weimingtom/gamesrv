--<<card 导表开始>>
local super = require "script.card"

ccard13506 = class("ccard13506",super,{
    sid = 13506,
    race = 3,
    name = "心灵震爆",
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
    magic_hurt = 5,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 21,
    desc = "对敌方英雄造成5点伤害。",
})

function ccard13506:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13506:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13506:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13506:onuse(target)
	local hurtvalue = self:gethurtvalue()
	target:addhp(-hurtvalue,self.id-hurtvalue,self.id-hurtvalue,self.id-hurtvalue,self.id-hurtvalue,self.id-hurtvalue,self.id-hurtvalue,self.id-hurtvalue,self.id)
end

return ccard13506
