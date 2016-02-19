--<<card 导表开始>>
local super = require "script.card.neutral.card165028"

ccard265028 = class("ccard265028",super,{
    sid = 265028,
    race = 6,
    name = "铁炉堡火枪手",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    atk = 2,
    hp = 2,
    crystalcost = 3,
    targettype = 33,
    desc = "战吼：造成1点伤害。",
})

function ccard265028:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard265028:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard265028:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard265028
