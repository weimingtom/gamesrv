--<<card 导表开始>>
local super = require "script.card.soil.card15510"

ccard25510 = class("ccard25510",super,{
    sid = 25510,
    race = 5,
    name = "埃隆巴克保护者",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
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
    atk = 8,
    hp = 8,
    crystalcost = 8,
    targettype = 0,
    desc = "嘲讽",
})

function ccard25510:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25510:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard25510:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard25510
