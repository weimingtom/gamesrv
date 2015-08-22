--<<card 导表开始>>
local super = require "script.card.water.card13509"

ccard23509 = class("ccard23509",super,{
    sid = 23509,
    race = 3,
    name = "神圣惩击",
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
    magic_hurt = 2,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 32,
    desc = "造成2点伤害。",
})

function ccard23509:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23509:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard23509:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard23509
