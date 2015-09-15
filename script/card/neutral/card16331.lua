--<<card 导表开始>>
local super = require "script.card.init"

ccard16331 = class("ccard16331",super,{
    sid = 16331,
    race = 6,
    name = "上古看守者",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 5,
    crystalcost = 2,
    targettype = 0,
    desc = "无法攻击。",
})

function ccard16331:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16331:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16331:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16331
