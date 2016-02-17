--<<card 导表开始>>
local super = require "script.card.neutral.card16100"

ccard26100 = class("ccard26100",super,{
    sid = 26100,
    race = 6,
    name = "幸运币",
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
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 0,
    targettype = 0,
    desc = "仅在本回合,获得一个法力水晶",
})

function ccard26100:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26100:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26100:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26100
