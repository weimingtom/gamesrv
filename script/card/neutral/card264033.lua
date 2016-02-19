--<<card 导表开始>>
local super = require "script.card.neutral.card164033"

ccard264033 = class("ccard264033",super,{
    sid = 264033,
    race = 6,
    name = "恐狼前锋",
    type = 202,
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "相邻的随从获得+1攻击力。",
})

function ccard264033:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264033:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264033:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264033
