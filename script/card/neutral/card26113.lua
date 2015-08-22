--<<card 导表开始>>
local super = require "script.card.neutral.card16113"

ccard26113 = class("ccard26113",super,{
    sid = 26113,
    race = 6,
    name = "游学者周卓",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "每当一个玩家施放一个法术时,复制该法术,将其置入另一个玩家的手牌。",
})

function ccard26113:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26113:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26113:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26113
