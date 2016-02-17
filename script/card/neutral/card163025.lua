--<<card 导表开始>>
local super = require "script.card.init"

ccard163025 = class("ccard163025",super,{
    sid = 163025,
    race = 6,
    name = "疯狂的炼金师",
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
    atk = 2,
    hp = 2,
    crystalcost = 2,
    targettype = 32,
    desc = "战吼：使一个随从的攻击力和生命值互换。",
})

function ccard163025:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard163025:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard163025:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard163025