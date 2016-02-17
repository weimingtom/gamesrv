--<<card 导表开始>>
local super = require "script.card.wood.card12506"

ccard22506 = class("ccard22506",super,{
    sid = 22506,
    race = 2,
    name = "真银之剑",
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
    atk = 4,
    hp = 2,
    crystalcost = 4,
    targettype = 0,
    desc = "每当你的英雄进攻时,为其恢复2点生命值。",
})

function ccard22506:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22506:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22506:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22506
