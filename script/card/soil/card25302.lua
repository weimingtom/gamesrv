--<<card 导表开始>>
local super = require "script.card.soil.card15302"

ccard25302 = class("ccard25302",super,{
    sid = 25302,
    race = 5,
    name = "滋养",
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
    crystalcost = 5,
    targettype = 0,
    desc = "抉择：获得2个法力水晶；或者抽3张牌。",
})

function ccard25302:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25302:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard25302:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard25302
