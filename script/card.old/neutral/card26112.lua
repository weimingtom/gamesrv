--<<card 导表开始>>
local super = require "script.card.neutral.card16112"

ccard26112 = class("ccard26112",super,{
    sid = 26112,
    race = 6,
    name = "玛里苟斯",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 5,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 12,
    crystalcost = 9,
    targettype = 0,
    desc = "法术伤害+5",
})

function ccard26112:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26112:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26112:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26112
