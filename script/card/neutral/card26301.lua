--<<card 导表开始>>
local super = require "script.card.neutral.card16301"

ccard26301 = class("ccard26301",super,{
    sid = 26301,
    race = 6,
    name = "奥术傀儡",
    magic_immune = 0,
    assault = 1,
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
    atk = 4,
    hp = 2,
    crystalcost = 3,
    targettype = 0,
    desc = "冲锋,战吼：使你的对手获得一个法力水晶。",
})

function ccard26301:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26301:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26301:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26301
