--<<card 导表开始>>
local super = require "script.card.wood.card12203"

ccard22203 = class("ccard22203",super,{
    sid = 22203,
    race = 2,
    name = "复仇之怒",
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
    type = 101,
    magic_hurt = 8,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 6,
    targettype = 23,
    desc = "造成8点伤害,随机分配给敌方角色。",
})

function ccard22203:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22203:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22203:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22203
