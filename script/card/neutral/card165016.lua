--<<card 导表开始>>
local super = require "script.card.init"

ccard165016 = class("ccard165016",super,{
    sid = 165016,
    race = 6,
    name = "暴风城勇士",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 6,
    crystalcost = 7,
    targettype = 0,
    desc = "你的其他随从获得+1/+1。",
})

function ccard165016:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard165016:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard165016:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard165016
