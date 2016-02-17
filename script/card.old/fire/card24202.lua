--<<card 导表开始>>
local super = require "script.card.fire.card14202"

ccard24202 = class("ccard24202",super,{
    sid = 24202,
    race = 4,
    name = "角斗士",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 301,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 2,
    crystalcost = 7,
    targettype = 0,
    desc = "你的英雄在攻击时具有免疫。",
})

function ccard24202:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24202:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24202:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24202
