--<<card 导表开始>>
local super = require "script.card"

ccard16421 = class("ccard16421",super,{
    sid = 16421,
    race = 6,
    name = "魔古山守望者",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 7,
    crystalcost = 4,
    targettype = 0,
    desc = "嘲讽",
})

function ccard16421:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16421:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16421:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16421
