--<<card 导表开始>>
local super = require "script.card.neutral.card164020"

ccard264020 = class("ccard264020",super,{
    sid = 264020,
    race = 6,
    name = "艾露恩的女祭司",
    type = 201,
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
    magic_hurt = 0,
    recoverhp = 4,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 4,
    crystalcost = 6,
    targettype = 0,
    desc = "战吼：为你的英雄恢复4点生命值。",
})

function ccard264020:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264020:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264020:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264020
