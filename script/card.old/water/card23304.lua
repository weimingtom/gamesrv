--<<card 导表开始>>
local super = require "script.card.water.card13304"

ccard23304 = class("ccard23304",super,{
    sid = 23304,
    race = 3,
    name = "奥金尼灵魂祭司",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 5,
    crystalcost = 4,
    targettype = 0,
    desc = "你的恢复生命值的牌和技能改为造成等量的伤害。",
})

function ccard23304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard23304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard23304
