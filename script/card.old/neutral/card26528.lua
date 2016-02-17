--<<card 导表开始>>
local super = require "script.card.neutral.card16528"

ccard26528 = class("ccard26528",super,{
    sid = 26528,
    race = 6,
    name = "铁炉堡火枪手",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 2,
    crystalcost = 3,
    targettype = 33,
    desc = "战吼：造成1点伤害。",
})

function ccard26528:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26528:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26528:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26528
