--<<card 导表开始>>
local super = require "script.card.neutral.card163034"

ccard263034 = class("ccard263034",super,{
    sid = 263034,
    race = 6,
    name = "憎恶",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
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
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "嘲讽,亡语：对所有角色造成2点伤害。",
})

function ccard263034:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard263034:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard263034:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard263034
