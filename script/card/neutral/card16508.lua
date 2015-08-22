--<<card 导表开始>>
local super = require "script.card"

ccard16508 = class("ccard16508",super,{
    sid = 16508,
    race = 6,
    name = "绿洲钳嘴龟",
    magic_immune = 0,
    assault = 0,
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
    atk = 2,
    hp = 7,
    crystalcost = 4,
    targettype = 0,
    desc = "None",
})

function ccard16508:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16508:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16508:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16508
