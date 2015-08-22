--<<card 导表开始>>
local super = require "script.card.neutral.card16307"

ccard26307 = class("ccard26307",super,{
    sid = 26307,
    race = 6,
    name = "烈日行者",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 1,
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
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "嘲讽。圣盾。",
})

function ccard26307:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26307:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26307:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26307
