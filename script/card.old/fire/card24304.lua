--<<card 导表开始>>
local super = require "script.card.fire.card14304"

ccard24304 = class("ccard24304",super,{
    sid = 24304,
    race = 4,
    name = "爆炸射击",
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
    magic_hurt = 5,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 5,
    targettype = 22,
    desc = "对1个随从造成5点伤害,并对相邻目标造成2点伤害。",
})

function ccard24304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24304
