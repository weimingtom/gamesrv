--<<card 导表开始>>
local super = require "script.card.neutral.card164038"

ccard264038 = class("ccard264038",super,{
    sid = 264038,
    race = 6,
    name = "叫嚣的中士",
    type = 201,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 1,
    crystalcost = 1,
    targettype = 32,
    desc = "战吼：在本回合中,使一个随从获得 +2 攻击力。",
})

function ccard264038:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264038:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264038:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264038
