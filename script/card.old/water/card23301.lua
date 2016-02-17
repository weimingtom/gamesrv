--<<card 导表开始>>
local super = require "script.card.water.card13301"

ccard23301 = class("ccard23301",super,{
    sid = 23301,
    race = 3,
    name = "神圣之火",
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
    type = 101,
    magic_hurt = 5,
    recoverhp = 5,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 6,
    targettype = 33,
    desc = "造成5点伤害。为你的英雄恢复5点生命值。",
})

function ccard23301:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23301:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard23301:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard23301
