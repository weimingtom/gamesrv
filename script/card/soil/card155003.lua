--<<card 导表开始>>
local super = require "script.card.init"

ccard155003 = class("ccard155003",super,{
    sid = 155003,
    race = 5,
    name = "激活",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 0,
    targettype = 0,
    desc = "仅在本回合中,获得2个法力水晶。",
})

function ccard155003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard155003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard155003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard155003
