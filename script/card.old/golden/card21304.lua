--<<card 导表开始>>
local super = require "script.card.golden.card11304"

ccard21304 = class("ccard21304",super,{
    sid = 21304,
    race = 1,
    name = "肯瑞托法师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    hp = 3,
    crystalcost = 3,
    targettype = 23,
    desc = "战吼：在本回合中你使用的下一个奥秘的法力值消耗为0",
})

function ccard21304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard21304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard21304
