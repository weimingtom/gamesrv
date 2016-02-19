--<<card 导表开始>>
local super = require "script.card.init"

ccard146004 = class("ccard146004",super,{
    sid = 146004,
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
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 4,
    hp = 4,
    crystalcost = 3,
    targettype = 0,
    desc = "None",
})

function ccard146004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard146004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard146004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard146004
