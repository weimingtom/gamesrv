--<<card 导表开始>>
local super = require "script.card.golden.card114006"

ccard214006 = class("ccard214006",super,{
    sid = 214006,
    race = 1,
    name = "巫师学徒",
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
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 2,
    crystalcost = 2,
    targettype = 23,
    desc = "你的法术的法力值消耗减少1点",
})

function ccard214006:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard214006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard214006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard214006
