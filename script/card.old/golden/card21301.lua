--<<card 导表开始>>
local super = require "script.card.golden.card11301"

ccard21301 = class("ccard21301",super,{
    sid = 21301,
    race = 1,
    name = "虚灵奥术师",
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
    hp = 3,
    crystalcost = 4,
    targettype = 23,
    desc = "当你在回合结束时控制任何奥秘,该随从便获得+2/+2",
})

function ccard21301:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21301:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard21301:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard21301
