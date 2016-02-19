--<<card 导表开始>>
local super = require "script.card.neutral.card163019"

ccard263019 = class("ccard263019",super,{
    sid = 263019,
    race = 6,
    name = "飞刀杂耍者",
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
    atk = 3,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "每当你召唤一个随从时,对一个随机敌方角色造成1点伤害。",
})

function ccard263019:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard263019:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard263019:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard263019
