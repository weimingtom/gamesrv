--<<card 导表开始>>
local super = require "script.card.water.card135003"

ccard235003 = class("ccard235003",super,{
    sid = 235003,
    race = 3,
    name = "暗言术：灭",
    type = 101,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 32,
    desc = "消灭一个攻击力大于或等于5的随从。",
})

function ccard235003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard235003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard235003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard235003
