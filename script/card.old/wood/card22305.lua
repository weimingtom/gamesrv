--<<card 导表开始>>
local super = require "script.card.wood.card12305"

ccard22305 = class("ccard22305",super,{
    sid = 22305,
    race = 2,
    name = "奥尔多卫士",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    hp = 3,
    crystalcost = 3,
    targettype = 22,
    desc = "战吼：使一个敌方随从的攻击力变为1。",
})

function ccard22305:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22305:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22305:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22305
