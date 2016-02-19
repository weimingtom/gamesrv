--<<card 导表开始>>
local super = require "script.card.fire.card144001"

ccard244001 = class("ccard244001",super,{
    sid = 244001,
    race = 4,
    name = "关门放狗",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
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
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 0,
    desc = "战场上每有一个敌方随从,便召唤一个1/1并具有冲锋的猎犬。",
})

function ccard244001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard244001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard244001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard244001
