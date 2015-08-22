--<<card 导表开始>>
local super = require "script.card.water.card13401"

ccard23401 = class("ccard23401",super,{
    sid = 23401,
    race = 3,
    name = "圣殿执行者",
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
    atk = 6,
    hp = 6,
    crystalcost = 6,
    targettype = 12,
    desc = "战吼：使一个友方随从获得+3生命值。",
})

function ccard23401:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23401:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard23401:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard23401
