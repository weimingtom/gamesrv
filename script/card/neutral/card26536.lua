--<<card 导表开始>>
local super = require "script.card.neutral.card16536"

ccard26536 = class("ccard26536",super,{
    sid = 26536,
    race = 6,
    name = "机械幼龙技工",
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
    atk = 2,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "战吼：召唤一个2/1的机械幼龙。",
})

function ccard26536:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26536:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26536:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26536
