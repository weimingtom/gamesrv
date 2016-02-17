--<<card 导表开始>>
local super = require "script.card.neutral.card164036"

ccard264036 = class("ccard264036",super,{
    sid = 264036,
    race = 6,
    name = "血帆袭击者",
    type = 204,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    atk = 2,
    hp = 3,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：获得等同于你的武器攻击力的攻击力。",
})

function ccard264036:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264036:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264036:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264036
