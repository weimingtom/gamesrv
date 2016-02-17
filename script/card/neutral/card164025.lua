--<<card 导表开始>>
local super = require "script.card.init"

ccard164025 = class("ccard164025",super,{
    sid = 164025,
    race = 6,
    name = "丛林猎豹",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 1,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 2,
    crystalcost = 3,
    targettype = 0,
    desc = "潜行",
})

function ccard164025:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard164025:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard164025:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard164025
