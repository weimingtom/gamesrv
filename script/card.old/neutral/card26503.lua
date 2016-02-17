--<<card 导表开始>>
local super = require "script.card.neutral.card16503"

ccard26503 = class("ccard26503",super,{
    sid = 26503,
    race = 6,
    name = "石牙野猪",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "冲锋",
})

function ccard26503:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26503:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26503:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26503
