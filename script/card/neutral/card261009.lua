--<<card 导表开始>>
local super = require "script.card.neutral.card161009"

ccard261009 = class("ccard261009",super,{
    sid = 261009,
    race = 6,
    name = "老瞎眼",
    type = 203,
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 1,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "冲锋,在战场上每有一个其他鱼人便获得+1攻击力。",
})

function ccard261009:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard261009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard261009:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard261009
