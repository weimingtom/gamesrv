--<<card 导表开始>>
local super = require "script.card.init"

ccard135004 = class("ccard135004",super,{
    sid = 135004,
    race = 3,
    name = "暗言术：痛",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 32,
    desc = "消灭一个攻击力小于或等于3的随从。",
})

function ccard135004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard135004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard135004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard135004
