--<<card 导表开始>>
local super = require "script.card.soil.card15404"

ccard25404 = class("ccard25404",super,{
    sid = 25404,
    race = 5,
    name = "利爪德鲁伊",
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
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "抉择：冲锋；或者+2生命值并具有嘲讽。",
})

function ccard25404:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25404:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard25404:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard25404
