--<<card 导表开始>>
local super = require "script.card.neutral.card16209"

ccard26209 = class("ccard26209",super,{
    sid = 26209,
    race = 6,
    name = "船长的鹦鹉",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：随机从你的牌库中将一张海盗牌置入你的手牌。",
})

function ccard26209:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26209:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26209:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26209
