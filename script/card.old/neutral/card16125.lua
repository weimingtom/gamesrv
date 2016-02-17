--<<card 导表开始>>
local super = require "script.card.init"

ccard16125 = class("ccard16125",super,{
    sid = 16125,
    race = 6,
    name = "阿莱克丝塔萨",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 8,
    hp = 8,
    crystalcost = 9,
    targettype = 31,
    desc = "战吼：使一个英雄的剩余生命值成为15。",
})

function ccard16125:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16125:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16125:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16125:onuse(target)
	local limit = 15
	local hp = target:gethp()
	target:addhp(limit-hp,self.id)
end

return ccard16125
