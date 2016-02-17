--<<card 导表开始>>
local super = require "script.card.init"

ccard161024 = class("ccard161024",super,{
    sid = 161024,
    race = 6,
    name = "迦顿男爵",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 5,
    crystalcost = 7,
    targettype = 0,
    desc = "在你的回合结束时,对所有其他角色造成2点伤害。",
})

function ccard161024:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard161024:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard161024:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard161024
