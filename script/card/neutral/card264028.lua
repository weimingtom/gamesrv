--<<card 导表开始>>
local super = require "script.card.neutral.card164028"

ccard264028 = class("ccard264028",super,{
    sid = 264028,
    race = 6,
    name = "冰霜元素",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 1,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 5,
    crystalcost = 5,
    targettype = 33,
    desc = "战吼：冻结一个角色。",
})

function ccard264028:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264028:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264028:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264028