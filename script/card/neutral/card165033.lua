--<<card 导表开始>>
local super = require "script.card.init"

ccard165033 = class("ccard165033",super,{
    sid = 165033,
    race = 6,
    name = "霜狼督军",
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
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "战吼：战场上每有1个其他友方随从,便获得+1/+1。",
})

function ccard165033:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard165033:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard165033:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard165033
