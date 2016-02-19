--<<card 导表开始>>
local super = require "script.card.water.card131001"

ccard231001 = class("ccard231001",super,{
    sid = 231001,
    race = 3,
    name = "先知维纶",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 7,
    crystalcost = 7,
    targettype = 0,
    desc = "使你的法术牌和英雄技能的伤害和治疗效果翻倍。",
})

function ccard231001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard231001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard231001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard231001
