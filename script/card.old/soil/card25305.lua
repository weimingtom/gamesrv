--<<card 导表开始>>
local super = require "script.card.soil.card15305"

ccard25305 = class("ccard25305",super,{
    sid = 25305,
    race = 5,
    name = "撕咬",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 0,
    desc = "在本回合中,使你的英雄获得+4攻击力和4点护甲值。",
})

function ccard25305:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25305:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard25305:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard25305
