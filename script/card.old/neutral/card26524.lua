--<<card 导表开始>>
local super = require "script.card.neutral.card16524"

ccard26524 = class("ccard26524",super,{
    sid = 26524,
    race = 6,
    name = "鱼人猎潮者",
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
    type = 203,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 1,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：召唤一个1/1的鱼人斥候。",
})

function ccard26524:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26524:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26524:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26524
