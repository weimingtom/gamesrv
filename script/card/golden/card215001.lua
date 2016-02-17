--<<card 导表开始>>
local super = require "script.card.golden.card115001"

ccard215001 = class("ccard215001",super,{
    sid = 215001,
    race = 1,
    name = "变形术",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 22,
    desc = "将一个仆从变成一个1/1的羊",
})

function ccard215001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard215001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard215001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard215001
