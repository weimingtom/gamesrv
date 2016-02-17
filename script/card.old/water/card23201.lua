--<<card 导表开始>>
local super = require "script.card.water.card13201"

ccard23201 = class("ccard23201",super,{
    sid = 23201,
    race = 3,
    name = "秘教暗影祭司",
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
    atk = 4,
    hp = 5,
    crystalcost = 6,
    targettype = 22,
    desc = "战吼：获得一个攻击力小于或等于2的敌方随从的控制权。",
})

function ccard23201:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23201:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard23201:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard23201
