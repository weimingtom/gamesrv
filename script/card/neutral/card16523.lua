--<<card 导表开始>>
local super = require "script.card.init"

ccard16523 = class("ccard16523",super,{
    sid = 16523,
    race = 6,
    name = "食人魔法师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 1,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "法术伤害+1",
})

function ccard16523:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16523:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16523:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16523
