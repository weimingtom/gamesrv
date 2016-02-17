--<<card 导表开始>>
local super = require "script.card.init"

ccard141001 = class("ccard141001",super,{
    sid = 141001,
    race = 4,
    name = "暴龙王克鲁什",
    type = 202,
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 8,
    hp = 8,
    crystalcost = 9,
    targettype = 0,
    desc = "冲锋",
})

function ccard141001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard141001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard141001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard141001
