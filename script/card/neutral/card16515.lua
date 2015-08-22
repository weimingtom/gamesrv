--<<card 导表开始>>
local super = require "script.card"

ccard16515 = class("ccard16515",super,{
    sid = 16515,
    race = 6,
    name = "作战傀儡",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 7,
    crystalcost = 7,
    targettype = 0,
    desc = "None",
})

function ccard16515:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16515:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16515:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16515
