--<<card 导表开始>>
local super = require "script.card.wood.card12508"

ccard22508 = class("ccard22508",super,{
    sid = 22508,
    race = 2,
    name = "列王守卫",
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
    recoverhp = 6,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 6,
    crystalcost = 7,
    targettype = 0,
    desc = "战吼：为你的英雄恢复6点生命值。",
})

function ccard22508:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22508:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22508:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22508
