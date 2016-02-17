--<<card 导表开始>>
local super = require "script.card.golden.card11506"

ccard21506 = class("ccard21506",super,{
    sid = 21506,
    race = 1,
    name = "水元素",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
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
    atk = 3,
    hp = 6,
    crystalcost = 4,
    targettype = 23,
    desc = "冻结任何受到水元素伤害的角色",
})

function ccard21506:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21506:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard21506:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard21506
