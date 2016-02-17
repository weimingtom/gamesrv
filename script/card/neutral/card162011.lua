--<<card 导表开始>>
local super = require "script.card.init"

ccard162011 = class("ccard162011",super,{
    sid = 162011,
    race = 6,
    name = "王牌猎人",
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
    atk = 4,
    hp = 2,
    crystalcost = 3,
    targettype = 32,
    desc = "战吼：消灭一个攻击力大于或等于7的随从。",
})

function ccard162011:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard162011:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard162011:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard162011
