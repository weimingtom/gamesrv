--<<card 导表开始>>
local super = require "script.card.wood.card12404"

ccard22404 = class("ccard22404",super,{
    sid = 22404,
    race = 2,
    name = "以眼还眼",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "奥秘：每当你的英雄受到伤害时,对敌方英雄造成等量的伤害。",
})

function ccard22404:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22404:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22404:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22404
