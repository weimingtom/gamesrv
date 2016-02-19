--<<card 导表开始>>
local super = require "script.card.neutral.card161016"

ccard261016 = class("ccard261016",super,{
    sid = 261016,
    race = 6,
    name = "伊利丹·怒风",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "每当你使用一张牌时,召唤一个2/1的埃辛诺斯烈焰。",
})

function ccard261016:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard261016:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard261016:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard261016
