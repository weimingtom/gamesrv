--<<card 导表开始>>
local super = require "script.card.neutral.card161011"

ccard261011 = class("ccard261011",super,{
    sid = 261011,
    race = 6,
    name = "米尔豪斯·法力风暴",
    type = 201,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：下个回合敌方法术的法力值消耗为（0）点。",
})

function ccard261011:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard261011:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard261011:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard261011
