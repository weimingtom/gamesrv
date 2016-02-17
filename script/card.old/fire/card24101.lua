--<<card 导表开始>>
local super = require "script.card.fire.card14101"

ccard24101 = class("ccard24101",super,{
    sid = 24101,
    race = 4,
    name = "暴龙王克鲁什",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 8,
    hp = 8,
    crystalcost = 9,
    targettype = 0,
    desc = "冲锋",
})

function ccard24101:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24101:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24101:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24101
