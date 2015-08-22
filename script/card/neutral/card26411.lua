--<<card 导表开始>>
local super = require "script.card.neutral.card16411"

ccard26411 = class("ccard26411",super,{
    sid = 26411,
    race = 6,
    name = "南海船工",
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
    type = 204,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "当你装备一把武器时,该随从获得冲锋。",
})

function ccard26411:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26411:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26411:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26411
