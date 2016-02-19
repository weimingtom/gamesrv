--<<card 导表开始>>
local super = require "script.card.neutral.card165029"

ccard265029 = class("ccard265029",super,{
    sid = 265029,
    race = 6,
    name = "古拉巴什狂暴者",
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
    atk = 2,
    hp = 7,
    crystalcost = 5,
    targettype = 0,
    desc = "每当该随从受到伤害时,获得+3攻击力。",
})

function ccard265029:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard265029:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard265029:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard265029
