--<<card 导表开始>>
local super = require "script.card.init"

ccard145007 = class("ccard145007",super,{
    sid = 145007,
    race = 4,
    name = "饥饿的秃鹫",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
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
    atk = 3,
    hp = 2,
    crystalcost = 5,
    targettype = 0,
    desc = "你每召唤1个野兽,抽1张牌。",
})

function ccard145007:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard145007:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard145007:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard145007
