--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12406"

ccard22406 = class("ccard22406",ccustomcard,{
    sid = 22406,
    race = 2,
    name = "银色保卫者",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 4,
    crystalcost = 1,
    targettype = 0,
    desc = "战吼：使一个友方随从获得圣盾。",
})

function ccard22406:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22406:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22406:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22406
