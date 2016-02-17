--<<card 导表开始>>
local super = require "script.card.golden.card11406"

ccard21406 = class("ccard21406",super,{
    sid = 21406,
    race = 1,
    name = "巫师学徒",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 2,
    crystalcost = 2,
    targettype = 23,
    desc = "你的法术的法力值消耗减少1点",
})

function ccard21406:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21406:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard21406:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard21406
