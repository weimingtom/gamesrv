--<<card 导表开始>>
local super = require "script.card.neutral.card166022"

ccard266022 = class("ccard266022",super,{
    sid = 266022,
    race = 6,
    name = "修理机器人",
    type = 206,
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
    recoverhp = 6,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 3,
    crystalcost = 1,
    targettype = 0,
    desc = "在你回合的结束阶段,为一个受到伤害的角色回复6点生命值。",
})

function ccard266022:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard266022:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard266022:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard266022
