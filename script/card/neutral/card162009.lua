--<<card 导表开始>>
local super = require "script.card.init"

ccard162009 = class("ccard162009",super,{
    sid = 162009,
    race = 6,
    name = "船长的鹦鹉",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：随机从你的牌库中将一张海盗牌置入你的手牌。",
})

function ccard162009:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard162009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard162009:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard162009
