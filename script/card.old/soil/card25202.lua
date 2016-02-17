--<<card 导表开始>>
local super = require "script.card.soil.card15202"

ccard25202 = class("ccard25202",super,{
    sid = 25202,
    race = 5,
    name = "战争古树",
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
    atk = 5,
    hp = 5,
    crystalcost = 7,
    targettype = 0,
    desc = "抉择：+5生命值并具有嘲讽；或者+5攻击力。",
})

function ccard25202:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25202:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard25202:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard25202
