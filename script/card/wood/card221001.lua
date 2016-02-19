--<<card 导表开始>>
local super = require "script.card.wood.card121001"

ccard221001 = class("ccard221001",super,{
    sid = 221001,
    race = 2,
    name = "提里奥·弗丁",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 1,
    warcry = 0,
    dieeffect = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 6,
    crystalcost = 8,
    targettype = 23,
    desc = "圣盾,嘲讽,亡语：装备一把5/3的灰烬使者。",
})

function ccard221001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard221001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard221001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard221001
