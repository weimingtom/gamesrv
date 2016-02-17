--<<card 导表开始>>
local super = require "script.card.neutral.card16314"

ccard26314 = class("ccard26314",super,{
    sid = 26314,
    race = 6,
    name = "精神控制技师",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "战吼：如果你的对手拥有4个或者更多随从,随机控制其中一个。",
})

function ccard26314:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26314:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26314:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26314
