--<<card 导表开始>>
local super = require "script.card.neutral.card16328"

ccard26328 = class("ccard26328",super,{
    sid = 26328,
    race = 6,
    name = "碧蓝幼龙",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 1,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "法术伤害+1,战吼：抽一张牌。",
})

function ccard26328:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26328:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26328:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26328
