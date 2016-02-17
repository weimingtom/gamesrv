--<<card 导表开始>>
local super = require "script.card.init"

ccard163011 = class("ccard163011",super,{
    sid = 163011,
    race = 6,
    name = "拉文霍德刺客",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 1,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 5,
    crystalcost = 7,
    targettype = 0,
    desc = "潜行",
})

function ccard163011:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard163011:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard163011:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard163011
