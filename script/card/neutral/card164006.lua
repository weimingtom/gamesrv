--<<card 导表开始>>
local super = require "script.card.init"

ccard164006 = class("ccard164006",super,{
    sid = 164006,
    race = 6,
    name = "风险投资公司雇佣兵",
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
    atk = 7,
    hp = 6,
    crystalcost = 5,
    targettype = 0,
    desc = "你的随从牌的法力值消耗增加（3）点。",
})

function ccard164006:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard164006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard164006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard164006
