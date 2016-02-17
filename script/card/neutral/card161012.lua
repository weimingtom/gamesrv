--<<card 导表开始>>
local super = require "script.card.init"

ccard161012 = class("ccard161012",super,{
    sid = 161012,
    race = 6,
    name = "玛里苟斯",
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
    magic_hurt_adden = 5,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 12,
    crystalcost = 9,
    targettype = 0,
    desc = "法术伤害+5",
})

function ccard161012:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard161012:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard161012:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard161012
