--<<card 导表开始>>
local super = require "script.card.golden.card11505"

ccard21505 = class("ccard21505",super,{
    sid = 21505,
    race = 1,
    name = "魔爆术",
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
    magic_hurt = 1,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "对所有敌方随从造成1点伤害",
})

function ccard21505:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21505:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard21505:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard21505
