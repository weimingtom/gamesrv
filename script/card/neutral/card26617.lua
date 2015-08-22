--<<card 导表开始>>
local super = require "script.card.neutral.card16617"

ccard26617 = class("ccard26617",super,{
    sid = 26617,
    race = 6,
    name = "潜行者的伎俩",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 4,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 33,
    desc = "造成4点伤害,抽一张牌",
})

function ccard26617:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26617:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26617:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26617
