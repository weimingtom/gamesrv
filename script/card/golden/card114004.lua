--<<card 导表开始>>
local super = require "script.card.init"

ccard114004 = class("ccard114004",super,{
    sid = 114004,
    race = 1,
    name = "法力浮龙",
    type = 201,
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
    hp = 3,
    crystalcost = 1,
    targettype = 23,
    desc = "每当你施放一个法术时,便获得+1攻击力",
})

function ccard114004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard114004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard114004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard114004
