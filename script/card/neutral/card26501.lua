--<<card 导表开始>>
local super = require "script.card.neutral.card16501"

ccard26501 = class("ccard26501",super,{
    sid = 26501,
    race = 6,
    name = "狼骑兵",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 1,
    crystalcost = 3,
    targettype = 0,
    desc = "冲锋",
})

function ccard26501:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26501:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26501:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26501
