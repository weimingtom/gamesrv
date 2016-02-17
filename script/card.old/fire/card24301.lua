--<<card 导表开始>>
local super = require "script.card.fire.card14301"

ccard24301 = class("ccard24301",super,{
    sid = 24301,
    race = 4,
    name = "长鬃草原狮",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "亡语：召唤2只2/2土狼。",
})

function ccard24301:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24301:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24301:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24301
