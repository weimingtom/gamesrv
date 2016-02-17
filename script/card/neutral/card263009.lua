--<<card 导表开始>>
local super = require "script.card.neutral.card163009"

ccard263009 = class("ccard263009",super,{
    sid = 263009,
    race = 6,
    name = "狂奔科多兽",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 5,
    crystalcost = 5,
    targettype = 22,
    desc = "战吼：随机消灭一个攻击力小于或等于2的敌方随从。",
})

function ccard263009:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard263009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard263009:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard263009
