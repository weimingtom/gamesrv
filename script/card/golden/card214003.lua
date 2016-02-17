--<<card 导表开始>>
local super = require "script.card.golden.card114003"

ccard214003 = class("ccard214003",super,{
    sid = 214003,
    race = 1,
    name = "冰枪术",
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
    crystalcost = 1,
    targettype = 33,
    desc = "使一个角色冻结,如果它已经冻结则改为造成4点伤害",
})

function ccard214003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard214003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard214003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard214003
