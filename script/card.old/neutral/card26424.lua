--<<card 导表开始>>
local super = require "script.card.neutral.card16424"

ccard26424 = class("ccard26424",super,{
    sid = 26424,
    race = 6,
    name = "麻风侏儒",
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
    type = 205,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "亡语：对敌方英雄造成2点伤害。",
})

function ccard26424:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26424:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26424:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26424
