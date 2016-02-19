--<<card 导表开始>>
local super = require "script.card.neutral.card164022"

ccard264022 = class("ccard264022",super,{
    sid = 264022,
    race = 6,
    name = "疯狂投弹者",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    desc = "战吼：造成3点伤害,随机由所有其他角色分摊。",
})

function ccard264022:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264022:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264022:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264022
