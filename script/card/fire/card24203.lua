--<<card 导表开始>>
local super = require "script.card.fire.card14203"

ccard24203 = class("ccard24203",super,{
    sid = 24203,
    race = 4,
    name = "狂野怒火",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 32,
    desc = "在本回合内,使1个野兽获得+2攻击和免疫。",
})

function ccard24203:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24203:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24203:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24203
