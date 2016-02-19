--<<card 导表开始>>
local super = require "script.card.soil.card153003"

ccard253003 = class("ccard253003",super,{
    sid = 253003,
    race = 5,
    name = "野蛮之击",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
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
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 32,
    desc = "对一个随从造成等同于你的英雄攻击力的伤害。",
})

function ccard253003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard253003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard253003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard253003
