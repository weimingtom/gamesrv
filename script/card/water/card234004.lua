--<<card 导表开始>>
local super = require "script.card.water.card134004"

ccard234004 = class("ccard234004",super,{
    sid = 234004,
    race = 3,
    name = "沉默",
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
    targettype = 32,
    desc = "沉默一个随从。",
})

function ccard234004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard234004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard234004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard234004
