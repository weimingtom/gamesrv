--<<card 导表开始>>
local super = require "script.card.fire.card146005"

ccard246005 = class("ccard246005",super,{
    sid = 246005,
    race = 4,
    name = "霍弗",
    type = 202,
    magic_immune = 0,
    assault = 1,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 4,
    hp = 2,
    crystalcost = 3,
    targettype = 0,
    desc = "None",
})

function ccard246005:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard246005:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard246005:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard246005
