--<<card 导表开始>>
local super = require "script.card"

ccard11602 = class("ccard11602",super,{
    sid = 11602,
    race = 1,
    name = "小羊",
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
    composechip = 0,
    decomposechip = 0,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 23,
    desc = "None",
})

function ccard11602:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11602:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11602:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard11602
