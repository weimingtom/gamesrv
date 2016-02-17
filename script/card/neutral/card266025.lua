--<<card 导表开始>>
local super = require "script.card.neutral.card166025"

ccard266025 = class("ccard266025",super,{
    sid = 266025,
    race = 6,
    name = "壮胆机器人3000型",
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
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 4,
    crystalcost = 1,
    targettype = 0,
    desc = "在你回合的结束阶段,使随机一名仆从获得+1/+1。",
})

function ccard266025:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard266025:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard266025:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard266025
