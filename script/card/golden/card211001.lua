--<<card 导表开始>>
local super = require "script.card.golden.card111001"

ccard211001 = class("ccard211001",super,{
    sid = 211001,
    race = 1,
    name = "大法师安东尼达斯",
    type = 201,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 7,
    crystalcost = 7,
    targettype = 23,
    desc = "每当你施放一个法术时,将一张‘火球术’置入你的手牌",
})

function ccard211001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard211001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard211001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard211001
