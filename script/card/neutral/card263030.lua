--<<card 导表开始>>
local super = require "script.card.neutral.card163030"

ccard263030 = class("ccard263030",super,{
    sid = 263030,
    race = 6,
    name = "愤怒的小鸡",
    type = 202,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "激怒：+5攻击力。",
})

function ccard263030:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard263030:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard263030:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard263030
