--<<card 导表开始>>
local super = require "script.card.neutral.card161014"

ccard261014 = class("ccard261014",super,{
    sid = 261014,
    race = 6,
    name = "火车王里诺艾",
    type = 201,
    magic_immune = 0,
    assault = 1,
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
    atk = 6,
    hp = 2,
    crystalcost = 5,
    targettype = 0,
    desc = "冲锋,战吼：为你的对手召唤2只1/1的雏龙。",
})

function ccard261014:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard261014:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard261014:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard261014
