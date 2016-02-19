--<<card 导表开始>>
local super = require "script.card.water.card132001"

ccard232001 = class("ccard232001",super,{
    sid = 232001,
    race = 3,
    name = "秘教暗影祭司",
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
    atk = 4,
    hp = 5,
    crystalcost = 6,
    targettype = 22,
    desc = "战吼：获得一个攻击力小于或等于2的敌方随从的控制权。",
})

function ccard232001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard232001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard232001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard232001
