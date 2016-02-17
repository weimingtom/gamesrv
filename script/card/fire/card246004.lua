--<<card 导表开始>>
local super = require "script.card.fire.card146004"

ccard246004 = class("ccard246004",super,{
    sid = 246004,
    race = 4,
    name = "米莎",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 1,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 4,
    hp = 4,
    crystalcost = 3,
    targettype = 0,
    desc = "None",
})

function ccard246004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard246004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard246004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard246004
