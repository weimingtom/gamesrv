--<<card 导表开始>>
local super = require "script.card.neutral.card16326"

ccard26326 = class("ccard26326",super,{
    sid = 26326,
    race = 6,
    name = "寒光先知",
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
    type = 203,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "战吼：使所有其他鱼人获得+2生命值。",
})

function ccard26326:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26326:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26326:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26326
