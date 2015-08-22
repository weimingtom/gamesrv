--<<card 导表开始>>
local super = require "script.card.neutral.card16627"

ccard26627 = class("ccard26627",super,{
    sid = 26627,
    race = 6,
    name = "香蕉",
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
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 32,
    desc = "使一个随从获得+1/+1",
})

function ccard26627:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26627:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26627:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26627
