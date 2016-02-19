--<<card 导表开始>>
local super = require "script.card.init"

ccard134001 = class("ccard134001",super,{
    sid = 134001,
    race = 3,
    name = "圣殿执行者",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    crystalcost = 6,
    targettype = 12,
    desc = "战吼：使一个友方随从获得+3生命值。",
})

function ccard134001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard134001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard134001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard134001
