--<<card 导表开始>>
local super = require "script.card.init"

ccard163006 = class("ccard163006",super,{
    sid = 163006,
    race = 6,
    name = "暮光幼龙",
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
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 1,
    crystalcost = 4,
    targettype = 0,
    desc = "战吼：你的每张手牌都会令暮光幼龙获得一次+1（生命值）效果",
})

function ccard163006:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard163006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard163006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard163006
