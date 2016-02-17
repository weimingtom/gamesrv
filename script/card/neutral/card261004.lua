--<<card 导表开始>>
local super = require "script.card.neutral.card161004"

ccard261004 = class("ccard261004",super,{
    sid = 261004,
    race = 6,
    name = "比斯巨兽",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
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
    atk = 10,
    hp = 6,
    crystalcost = 6,
    targettype = 0,
    desc = "亡语：为你的对手召唤1个3/3的芬克·恩霍尔。",
})

function ccard261004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard261004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard261004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard261004
