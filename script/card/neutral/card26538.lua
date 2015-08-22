--<<card 导表开始>>
local super = require "script.card.neutral.card16538"

ccard26538 = class("ccard26538",super,{
    sid = 26538,
    race = 6,
    name = "达拉然法师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 1,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 4,
    crystalcost = 3,
    targettype = 0,
    desc = "法术伤害+1",
})

function ccard26538:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26538:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26538:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26538
