--<<card 导表开始>>
local super = require "script.card.neutral.card161020"

ccard261020 = class("ccard261020",super,{
    sid = 261020,
    race = 6,
    name = "死亡之翼",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 12,
    hp = 12,
    crystalcost = 10,
    targettype = 0,
    desc = "战吼：消灭所有其他随从,并弃掉你的手牌。",
})

function ccard261020:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard261020:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard261020:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard261020
