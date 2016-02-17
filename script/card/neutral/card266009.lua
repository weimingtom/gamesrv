--<<card 导表开始>>
local super = require "script.card.neutral.card166009"

ccard266009 = class("ccard266009",super,{
    sid = 266009,
    race = 6,
    name = "梦魇",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 0,
    targettype = 32,
    desc = "使一名仆从获得+5/+5效果,下一轮开始前,该仆从将被摧毁。",
})

function ccard266009:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard266009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard266009:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard266009
