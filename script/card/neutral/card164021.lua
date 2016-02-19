--<<card 导表开始>>
local super = require "script.card.init"

ccard164021 = class("ccard164021",super,{
    sid = 164021,
    race = 6,
    name = "魔古山守望者",
    type = 201,
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 7,
    crystalcost = 4,
    targettype = 0,
    desc = "嘲讽",
})

function ccard164021:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard164021:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard164021:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard164021
