--<<card 导表开始>>
local super = require "script.card.fire.card14502"

ccard24502 = class("ccard24502",super,{
    sid = 24502,
    race = 4,
    name = "深林狼",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "你的其他野兽获得+1攻击。",
})

function ccard24502:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24502:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24502:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24502
