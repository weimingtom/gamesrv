--<<card 导表开始>>
local super = require "script.card.init"

ccard132003 = class("ccard132003",super,{
    sid = 132003,
    race = 3,
    name = "暗影形态",
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
    crystalcost = 3,
    targettype = 0,
    desc = "你的英雄技能变为“造成2点伤害”,如果已经处于暗影形态下：改为“造成3点伤害”。",
})

function ccard132003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard132003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard132003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard132003
