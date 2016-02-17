--<<card 导表开始>>
local super = require "script.card.wood.card122001"

ccard222001 = class("ccard222001",super,{
    sid = 222001,
    race = 2,
    name = "公正之剑",
    type = 301,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 5,
    crystalcost = 3,
    targettype = 0,
    desc = "每当你召唤一个随从,使它获得+1/+1,这把武器失去1点耐久度。",
})

function ccard222001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard222001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard222001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard222001
