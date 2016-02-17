--<<card 导表开始>>
local super = require "script.card.neutral.card166015"

ccard266015 = class("ccard266015",super,{
    sid = 266015,
    race = 6,
    name = "芬克·恩霍尔",
    type = 202,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 3,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "None",
})

function ccard266015:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard266015:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard266015:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard266015
